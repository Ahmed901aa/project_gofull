import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/features/location/data/nominatim_service.dart';

typedef GpsLocation = ({String address, double lat, double lng});

Future<bool> _ensurePermission() async {
  var p = await Geolocator.checkPermission();
  if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
  return p != LocationPermission.denied && p != LocationPermission.deniedForever;
}

/// Requests GPS permission and animates [controller] to the current position.
Future<void> animateToCurrentLocation(GoogleMapController? controller) async {
  if (!await _ensurePermission()) return;
  try {
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
    controller?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15),
    );
  } catch (_) {}
}

/// Gets current GPS position and reverse-geocodes it via Nominatim.
/// Returns null if permission denied or on any error.
Future<GpsLocation?> fetchCurrentGpsLocation(NominatimService service) async {
  if (!await _ensurePermission()) return null;
  try {
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
    final name =
        await service.reverseGeocode(LatLng(pos.latitude, pos.longitude));
    return (address: name, lat: pos.latitude, lng: pos.longitude);
  } catch (_) {
    return null;
  }
}
