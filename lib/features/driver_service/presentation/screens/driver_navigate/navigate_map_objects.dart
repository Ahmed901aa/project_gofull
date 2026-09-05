import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/tracking_colors.dart';

/// Builds the markers and route polyline shown on the navigation map.
({Set<Marker> markers, Set<Polyline> polylines}) buildNavigateMapObjects(
  BuildContext context, {
  required LatLng destination,
  required LatLng? providerPosition,
  required bool isToCustomer,
  required String address,
}) {
  final markers = <Marker>{
    Marker(
      markerId: const MarkerId('destination'),
      position: destination,
      infoWindow: InfoWindow(
        title: isToCustomer
            ? S.of(context).customerLocationMarker
            : S.of(context).deliveryPointMarker,
        snippet: address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
  };

  var polylines = <Polyline>{};
  if (providerPosition != null) {
    markers.add(
      Marker(
        markerId: const MarkerId('provider'),
        position: providerPosition,
        infoWindow: InfoWindow(title: S.of(context).myLocationMarker),
        // Single-hue green tracking scheme (no blue) — provider gets a
        // slightly darker green than the destination so the two markers
        // are still distinguishable on the map.
        icon: BitmapDescriptor.defaultMarkerWithHue(140),
      ),
    );
    // Solid line — dash patterns cause memory leaks on iOS
    polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [providerPosition, destination],
        color: TrackingColors.accent.withValues(alpha: 0.7),
        width: 4,
      ),
    };
  }

  return (markers: markers, polylines: polylines);
}
