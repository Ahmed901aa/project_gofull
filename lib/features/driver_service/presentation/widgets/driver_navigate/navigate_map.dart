import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigateMap extends StatelessWidget {
  final LatLng destination;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final void Function(GoogleMapController) onMapCreated;

  const NavigateMap({
    super.key,
    required this.destination,
    required this.markers,
    required this.polylines,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) => GoogleMap(
        initialCameraPosition: CameraPosition(target: destination, zoom: 14),
        onMapCreated: onMapCreated,
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        style: '[]', // Force light mode regardless of app theme
      );
}
