import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';

class FuelScreen extends StatelessWidget {
  const FuelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar
            _buildAppBar(context),

            // Location cards (departure + destination)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: _buildLocationSection(context),
            ),
            SizedBox(height: Sizes.s24),

            // Fuel type header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Text(
                AppStrings.selectFuelType,
                style: getBoldStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s18,
                ),
              ),
            ),
            SizedBox(height: Sizes.s12),

            // Fuel type cards
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                physics: const BouncingScrollPhysics(),
                children: [
                  _FuelTypeCard(
                    icon: Icons.local_gas_station_rounded,
                    title: AppStrings.gasoline91,
                    subtitle: 'أوكتان 91',
                    onTap: () {
                      _navigateToLocationFlow(context);
                    },
                  ),
                  SizedBox(height: Sizes.s12),
                  _FuelTypeCard(
                    icon: Icons.local_gas_station_rounded,
                    title: AppStrings.gasoline95,
                    subtitle: 'أوكتان 95',
                    onTap: () {
                      _navigateToLocationFlow(context);
                    },
                  ),
                  SizedBox(height: Sizes.s12),
                  _FuelTypeCard(
                    icon: Icons.local_gas_station_rounded,
                    title: AppStrings.diesel,
                    subtitle: 'ديزل عادي',
                    onTap: () {
                      _navigateToLocationFlow(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s12,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 22.sp,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(width: Insets.s12),
          Text(
            AppStrings.fuelSupply,
            style: getBoldStyle(
              color: AppColors.black,
              fontSize: FontSize.s18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          // Departure
          _LocationRow(
            icon: Icons.radio_button_checked_rounded,
            iconColor: AppColors.primary,
            label: AppStrings.departurePoint,
            value: 'اختر نقطة الانطلاق',
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.locationSearch,
                arguments: const LocationSearchArgs(
                  title: AppStrings.departurePoint,
                ),
              );
            },
          ),

          // Dotted line
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Column(
              children: List.generate(
                3,
                (_) => Container(
                  width: 2,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: AppColors.grey.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),

          // Destination
          _LocationRow(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.error,
            label: AppStrings.deliveryDestination,
            value: 'اختر وجهة التوصيل',
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.locationSearch,
                arguments: const LocationSearchArgs(
                  title: AppStrings.deliveryDestination,
                  showCurrentLocation: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToLocationFlow(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.locationSearch,
      arguments: const LocationSearchArgs(
        title: AppStrings.departurePoint,
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: iconColor),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: getMediumStyle(
                    color: AppColors.darkGrey,
                    fontSize: FontSize.s14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: AppColors.grey,
            size: 22.sp,
          ),
        ],
      ),
    );
  }
}

class _FuelTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FuelTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
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
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 26.sp,
              ),
            ),
            SizedBox(width: Insets.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getSemiBoldStyle(
                      color: AppColors.black,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              color: AppColors.grey,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
