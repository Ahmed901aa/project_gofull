import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PickerMap extends StatelessWidget {
  final LatLng initialPosition;
  final void Function(GoogleMapController) onMapCreated;
  final void Function(CameraPosition) onCameraMove;
  final VoidCallback onCameraIdle;

  const PickerMap({
    super.key,
    required this.initialPosition,
    required this.onMapCreated,
    required this.onCameraMove,
    required this.onCameraIdle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: initialPosition, zoom: 13),
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onCameraMove: onCameraMove,
          onCameraIdle: onCameraIdle,
        ),
        // Fixed centre pin — tip stays at map center
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: context.colors.primary, size: 48.sp),
              Container(
                width: 8.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 52.h),
            ],
          ),
        ),
      ],
    );
  }
}
