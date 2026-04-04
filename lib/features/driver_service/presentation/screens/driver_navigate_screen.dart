import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';

class DriverNavigateScreen extends StatefulWidget {
  final DriverNavigateArgs args;
  const DriverNavigateScreen({super.key, required this.args});

  @override
  State<DriverNavigateScreen> createState() => _DriverNavigateScreenState();
}

class _DriverNavigateScreenState extends State<DriverNavigateScreen> {
  GoogleMapController? _mapController;

  bool get _isToCustomer => widget.args.navigationType == 'to_customer';

  LatLng get _targetLocation => LatLng(
        widget.args.lat ?? 30.0444,
        widget.args.lng ?? 31.2357,
      );

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Full-screen Google Map
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _targetLocation,
                zoom: 14.0,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('destination'),
                  position: _targetLocation,
                  infoWindow: InfoWindow(
                    title: _isToCustomer ? 'موقع العميل' : 'وجهة التوصيل',
                  ),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),
          // Map control buttons
          Positioned(
            left: Insets.s16,
            bottom: 280.h,
            child: Column(
              children: [
                _circleButton(Icons.refresh_rounded, () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_targetLocation),
                  );
                }),
                SizedBox(height: Insets.s8),
                _circleButton(Icons.my_location_rounded, () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_targetLocation),
                  );
                }),
              ],
            ),
          ),
          // Bottom panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 22.sp,
                    color: const Color(0xFF0E0E0E),
                  ),
                ),
                Text(
                  _isToCustomer ? 'التحرك للعميل' : 'التحرك لوجهة التوصيل',
                  style: getBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s20,
                  ),
                ),
                Icon(
                  Icons.info_outline_rounded,
                  size: 24.sp,
                  color: const Color(0xFF0E0E0E),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s20, Insets.s16, Insets.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.s24),
          topRight: Radius.circular(AppRadius.s24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Destination label + address
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  size: 20.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: Insets.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isToCustomer ? 'موقع العميل' : 'وجهة التوصيل',
                      style: getMediumStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.s12,
                      ),
                    ),
                    SizedBox(height: Insets.s4),
                    Text(
                      widget.args.address,
                      style: getMediumStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s16),
          // Phone call + Google Maps row
          Row(
            children: [
              GestureDetector(
                onTap: () => _callCustomer(),
                child: Container(
                  width: Sizes.s48,
                  height: Sizes.s48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.divider),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(Icons.phone, size: 22.sp, color: AppColors.primary),
                ),
              ),
              SizedBox(width: Insets.s12),
              Expanded(
                child: AppButton(
                  text: 'فتح في خرائط جوجل',
                  isOutlined: true,
                  onPressed: () => _openGoogleMaps(),
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s16),
          // Main action button
          AppButton(
            text: 'وصلت - بدء التوثيق',
            onPressed: () {
              final docType = _isToCustomer ? 'pickup' : 'delivery';
              Navigator.pushNamed(
                context,
                Routes.driverDocumentation,
                arguments: DriverDocumentationArgs(
                  orderId: widget.args.orderId,
                  documentationType: docType,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 22.sp, color: AppColors.darkGrey),
      ),
    );
  }

  Future<void> _openGoogleMaps() async {
    final lat = widget.args.lat ?? 30.0444;
    final lng = widget.args.lng ?? 31.2357;
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callCustomer() async {
    final uri = Uri.parse('tel:');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
