import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_map_widget.dart';

class MapSelectionScreen extends StatelessWidget {
  final MapSelectionArgs args;
  const MapSelectionScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppMapWidget(
        initialLat: args.initialLat,
        initialLng: args.initialLng,
        onLocationSelected: (LatLng _, String address) {
          Navigator.pop(context, address);
        },
      ),
    );
  }
}
