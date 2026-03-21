import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            // Full-screen map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 15,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: (position) {
                _selectedLocation = position.target;
              },
              onCameraIdle: _updateAddress,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),

            // Center pin marker
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: Icon(
                  Icons.location_on,
                  size: 52.sp,
                  color: AppColors.primary,
                ),
              ),
            ),

            // Top bar (status bar + title + search bar)
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTopBar(),
                  _buildAddressSearchBar(),
                ],
              ),
            ),

            // My location button (bottom left)
            Positioned(
              left: Insets.s16,
              bottom: 110.h,
              child: GestureDetector(
                onTap: _goToMyLocation,
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
              ),
            ),

            // Bottom confirm button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s12,
      ),
      child: Row(
        children: [
          // Close button (start in RTL = right visually)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 18.sp, color: AppColors.black),
            ),
          ),
          // Title centered
          Expanded(
            child: Text(
              AppStrings.currentLocation,
              style: getBoldStyle(
                color: AppColors.black,
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Search icon (end in RTL = left visually)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                size: 18.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSearchBar() {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        Insets.s16,
        0,
        Insets.s16,
        Insets.s12,
      ),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.grey, size: 20.sp),
            SizedBox(width: Insets.s8),
            Expanded(
              child: Text(
                _address,
                style: getMediumStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(width: Insets.s8),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, color: AppColors.grey, size: 18.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Insets.s16,
        Insets.s16,
        Insets.s16,
        32.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.s24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, _address),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            elevation: 0,
          ),
          child: Text(
            AppStrings.confirm,
            style: getBoldStyle(
              color: AppColors.white,
              fontSize: FontSize.s16,
            ),
          ),
        ),
      ),
    );
  }

  void _updateAddress() {
    // In production: use geocoding package to reverse geocode _selectedLocation
    setState(() {
      _address = 'أول المنصورة-قسم أول-شارع الحوار';
    });
  }

  void _goToMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }
}
