import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_geo.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_map_state_mixin.dart';

/// Live-location tracking and camera fitting. Relies on [NavigateMapStateMixin]
/// for the shared map state it reads and updates.
///
/// Geolocator's platform position stream is SINGLE-subscription. A plain
/// `.asBroadcastStream()` is not enough: when the last listener cancels
/// (navigate screen disposes) it cancels the underlying platform stream for
/// good, and the *next* screen that subscribes hits
/// "Bad state: Stream has already been listened to".
///
/// [SharedPositionStream] owns one long-lived Geolocator subscription and
/// fans it out through a broadcast controller. It (re)starts the platform
/// stream lazily on first listener and tears it down when nobody is
/// listening, so screens can subscribe/unsubscribe in any order — including
/// the pushReplacement case where the new route inits before the old
/// one disposes.
class SharedPositionStream {
  SharedPositionStream._();
  static final SharedPositionStream instance = SharedPositionStream._();

  static const _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 20, // metres
  );

  StreamSubscription<Position>? _source;
  late final StreamController<Position> _controller =
      StreamController<Position>.broadcast(
    onListen: _startSource,
    onCancel: _stopSourceIfIdle,
  );

  Stream<Position> get stream => _controller.stream;

  void _startSource() {
    if (_source != null) return; // already running
    _source = Geolocator.getPositionStream(locationSettings: _settings).listen(
      _controller.add,
      onError: (Object e, StackTrace st) {
        _controller.addError(e, st);
        // Platform stream died — drop it so the next listener restarts it.
        _source?.cancel();
        _source = null;
      },
      cancelOnError: false,
    );
  }

  void _stopSourceIfIdle() {
    if (_controller.hasListener) return;
    _source?.cancel();
    _source = null;
  }
}

mixin NavigateLocationMixin<T extends StatefulWidget>
    on State<T>, NavigateMapStateMixin<T> {
  Future<bool> _ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<Position> _position(int seconds) => Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: seconds)),
      );

  /// Get initial position then start periodic updates.
  Future<void> initLocation() async {
    try {
      if (await _ensurePermission()) {
        final pos = await _position(8);
        if (mounted) {
          providerPosition = LatLng(pos.latitude, pos.longitude);
          rebuildMapObjects();
          setState(() {});
          fitBounds();
        }
      }
    } catch (_) {}
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _sendCurrentLocation();

    // Movement-based updates: fires only after moving ≥ 20 m — far
    // kinder to battery and the API than the old fixed 10 s timer.
    locationSub = SharedPositionStream.instance.stream
        .listen(_onPosition, onError: (Object e) {
      debugPrint('Location stream error: $e');
    });

    // Keepalive: refresh the backend position even when stationary so
    // dispatch radius filtering keeps working.
    locationTimer = Timer.periodic(
        const Duration(seconds: 45), (_) => _sendCurrentLocation());
  }

  Future<void> _sendCurrentLocation() async {
    try {
      final pos = await _position(5);
      await _onPosition(pos);
    } catch (e) {
      debugPrint('Failed to read GPS position: $e');
    }
  }

  Future<void> _onPosition(Position pos) async {
    try {
      await sl<ApiClient>().dio.patch('/provider/profile/location',
          data: {'latitude': pos.latitude, 'longitude': pos.longitude});
    } catch (e) {
      // Keep the UI updating even if the network call fails
      debugPrint('Failed to send location: $e');
    }
    if (!mounted) return;

    providerPosition = LatLng(pos.latitude, pos.longitude);
    final km = haversineKm(
        pos.latitude, pos.longitude, destination.latitude, destination.longitude);
    remainingDistance = '${km.toStringAsFixed(1)} ${S.of(context).kmUnit}';
    rebuildMapObjects();
    setState(() {});
    mapController?.animateCamera(CameraUpdate.newLatLng(providerPosition!));
  }

  Future<void> moveToCurrentLocation() async {
    if (providerPosition != null) {
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(providerPosition!, 15));
      return;
    }
    try {
      if (!await _ensurePermission()) return;
      final pos = await _position(10);
      if (!mounted) return;
      mapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15));
    } catch (_) {}
  }

  /// Fit camera to show both provider and destination markers.
  void fitBounds() {
    if (providerPosition == null || mapController == null) return;
    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(boundsFor(providerPosition!, destination), 80),
    );
  }
}
