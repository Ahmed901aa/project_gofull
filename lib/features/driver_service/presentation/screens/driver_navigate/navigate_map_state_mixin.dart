import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_map_objects.dart';

// Default map center: Tripoli, Libya.
const _defaultLat = 32.8872;
const _defaultLng = 13.1913;

/// Holds the navigation screen's map state (controller, live position, cached
/// markers/polylines) and rebuilds the map objects on demand.
mixin NavigateMapStateMixin<T extends StatefulWidget> on State<T> {
  DriverNavigateArgs get navArgs;

  GoogleMapController? mapController;
  Timer? locationTimer;
  String remainingDistance = '';
  LatLng? providerPosition;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  LatLng get destination =>
      LatLng(navArgs.lat ?? _defaultLat, navArgs.lng ?? _defaultLng);

  bool get isToCustomer => navArgs.navigationType == 'to_customer';

  void rebuildMapObjects() {
    final objects = buildNavigateMapObjects(
      context,
      destination: destination,
      providerPosition: providerPosition,
      isToCustomer: isToCustomer,
      address: navArgs.address,
    );
    markers = objects.markers;
    polylines = objects.polylines;
  }

  void disposeLocation() {
    locationTimer?.cancel();
    mapController?.dispose();
  }
}
