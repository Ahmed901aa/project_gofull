import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';

class MapSelectionScreen extends StatefulWidget {
  final MapSelectionArgs args;
  const MapSelectionScreen({super.key, required this.args});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  late LatLng _selectedLocation;
  String _address = '';
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(
      widget.args.initialLat ?? 32.9022,
      widget.args.initialLng ?? 13.1800,
    );
    _address = 'المنصورة، طرابلس';
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              _selectedLocation = position.target;
            },
            onCameraIdle: () {
              _updateAddress();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Center pin
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 36.h),
              child: Icon(
                Icons.location_on,
                size: 48.sp,
                color: AppColors.primary,
              ),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.s16,
                vertical: Insets.s8,
              ),
              child: Row(
                children: [
                  // Search bar
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.s12,
                          vertical: Insets.s12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.s12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: AppColors.grey,
                              size: 20.sp,
                            ),
                            SizedBox(width: Insets.s8),
                            Expanded(
                              child: Text(
                                _address.isNotEmpty
                                    ? _address
                                    : AppStrings.searchLocation,
                                style: getRegularStyle(
                                  color: _address.isNotEmpty
                                      ? AppColors.black
                                      : AppColors.grey,
                                  fontSize: FontSize.s14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Insets.s8),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.black,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // My location button
          Positioned(
            left: Insets.s16,
            bottom: 120.h,
            child: GestureDetector(
              onTap: _goToMyLocation,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
            child: Container(
              padding: EdgeInsets.fromLTRB(
                Insets.s16,
                Insets.s16,
                Insets.s16,
                Insets.s32,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.s24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Address display
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                      SizedBox(width: Insets.s8),
                      Expanded(
                        child: Text(
                          _address.isNotEmpty ? _address : '...',
                          style: getMediumStyle(
                            color: AppColors.black,
                            fontSize: FontSize.s14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Sizes.s16),
                  AppButton(
                    text: AppStrings.confirm,
                    isLoading: _isLoading,
                    onPressed: () {
                      // Pop with selected location result
                      Navigator.pop(context, _address);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateAddress() {
    // In a real app, use geocoding to get address from coordinates
    setState(() {
      _address = 'المنصورة، طرابلس';
    });
  }

  void _goToMyLocation() {
    // In a real app, use geolocator to get current position
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }
}
