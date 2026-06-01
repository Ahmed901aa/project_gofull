import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef GpsLocation = ({String address, double lat, double lng});

/// Shared permission check used by both helpers below.
Future<bool> _ensurePermission() async {
  var p = await Geolocator.checkPermission();
  if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
  return p != LocationPermission.denied &&
      p != LocationPermission.deniedForever;
}

/// Requests GPS permission and animates [controller] to the current position.
Future<void> animateToCurrentLocation(GoogleMapController? controller) async {
  if (!await _ensurePermission()) return;
  try {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    controller?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15),
    );
  } catch (_) {}
}

/// Gets the current GPS position and reverse-geocodes it using the provided
/// [reverseGeocode] function (e.g. GooglePlacesService.reverseGeocode).
/// Returns null if permission is denied or on any error.
Future<GpsLocation?> fetchCurrentGpsLocation(
  Future<String> Function(double lat, double lng) reverseGeocode,
) async {
  if (!await _ensurePermission()) return null;
  try {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    final name = await reverseGeocode(pos.latitude, pos.longitude);
    return (address: name, lat: pos.latitude, lng: pos.longitude);
  } catch (_) {
    return null;
  }
}
