import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../widgets/map_address_bar.dart';
import '../widgets/map_confirm_button.dart';
import '../widgets/map_top_bar.dart';

class MapSelectionScreen extends StatefulWidget {
  final MapSelectionArgs args;
  const MapSelectionScreen({super.key, required this.args});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  late LatLng _selectedLocation;
  String _address = 'أول المنصورة-قسم أول-شارع الحوار';

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(
      widget.args.initialLat ?? 31.0409,
      widget.args.initialLng ?? 31.3785,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _updateAddress() {
    // In production: use geocoding package to reverse geocode _selectedLocation
    setState(() { _address = 'أول المنصورة-قسم أول-شارع الحوار'; });
  }

  void _goToMyLocation() {
    _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _selectedLocation, zoom: 15),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: (position) { _selectedLocation = position.target; },
              onCameraIdle: _updateAddress,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: Icon(Icons.location_on, size: 52.sp, color: AppColors.primary),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MapTopBar(),
                  MapAddressBar(address: _address),
                ],
              ),
            ),
            Positioned(
              left: Insets.s16,
              bottom: 110.h,
              child: GestureDetector(
                onTap: _goToMyLocation,
                child: Container(
                  width: 48.w, height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Icon(Icons.my_location_rounded, color: AppColors.primary, size: 22.sp),
                ),
              ),
            ),
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: MapConfirmButton(address: _address),
            ),
          ],
        ),
      ),
    );
  }
}
