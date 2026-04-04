import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';

class DriverNavigateScreen extends StatelessWidget {
  final DriverNavigateArgs args;
  const DriverNavigateScreen({super.key, required this.args});

  bool get _isToCustomer => args.navigationType == 'to_customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Map placeholder
          Positioned.fill(
            child: Container(
              color: AppColors.neutral400,
              child: Center(
                child: Text(
                  'خريطة الملاحة',
                  style: getMediumStyle(color: AppColors.grey, fontSize: FontSize.s18),
                ),
              ),
            ),
          ),
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),
          // Side buttons
          Positioned(
            left: Insets.s16,
            bottom: 280.h,
            child: Column(
              children: [
                _circleButton(Icons.refresh_rounded, () {}),
                SizedBox(height: Insets.s8),
                _circleButton(Icons.my_location_rounded, () {}),
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
                  child: Icon(Icons.arrow_back_ios_rounded, size: 22.sp, color: const Color(0xFF0E0E0E)),
                ),
                Text(
                  _isToCustomer ? AppStrings.navigateToCustomer : AppStrings.navigateToDestination,
                  style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                ),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
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
          // Destination address
          Row(
            children: [
              Icon(Icons.location_on, size: 22.sp, color: AppColors.primary),
              SizedBox(width: Insets.s8),
              Expanded(
                child: Text(
                  args.address,
                  style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s16),
          // Google Maps + Phone row
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: AppStrings.openInGoogleMaps,
                  isOutlined: true,
                  onPressed: () => _openGoogleMaps(),
                ),
              ),
              SizedBox(width: Insets.s12),
              GestureDetector(
                onTap: () => _callCustomer(),
                child: Container(
                  width: Sizes.s48,
                  height: Sizes.s48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone, size: 22.sp, color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s16),
          // Arrived button
          AppButton(
            text: AppStrings.arrivedStartDoc,
            onPressed: () {
              final docType = _isToCustomer ? 'pickup' : 'delivery';
              Navigator.pushNamed(
                context,
                Routes.driverDocumentation,
                arguments: DriverDocumentationArgs(
                  orderId: args.orderId,
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
    final lat = args.lat ?? 31.0409;
    final lng = args.lng ?? 31.3785;
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
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
