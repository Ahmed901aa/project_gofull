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
    locationTimer = Timer.periodic(const Duration(seconds: 10), (_) => _sendCurrentLocation());
  }

  Future<void> _sendCurrentLocation() async {
    try {
      final pos = await _position(5);
      sl<ApiClient>().dio.patch('/provider/profile/location',
          data: {'latitude': pos.latitude, 'longitude': pos.longitude});
      if (!mounted) return;

      providerPosition = LatLng(pos.latitude, pos.longitude);
      final km = haversineKm(
          pos.latitude, pos.longitude, destination.latitude, destination.longitude);
      remainingDistance = '${km.toStringAsFixed(1)} ${S.of(context).kmUnit}';
      rebuildMapObjects();
      setState(() {});
      mapController?.animateCamera(CameraUpdate.newLatLng(providerPosition!));
    } catch (_) {}
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
