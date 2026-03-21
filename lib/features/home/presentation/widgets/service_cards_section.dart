import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';

class ServiceCardsSection extends StatelessWidget {
  const ServiceCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ServiceCard(
                svgAsset: IconAssets.towTruck,
                title: AppStrings.towTruckService,
                subtitle: AppStrings.towTruckServiceDesc,
                onTap: () {
                  // TODO: Navigate to car towing flow
                },
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: _ServiceCard(
                icon: Icons.local_car_wash_rounded,
                title: 'غسيل سيارات',
                subtitle: 'غسيل متنقل لسيارتك',
                onTap: () {
                  // TODO: Navigate to car wash flow
                },
              ),
            ),
          ],
        ),
        SizedBox(height: Insets.s12),
        Row(
          children: [
            Expanded(
              child: _ServiceCard(
                icon: Icons.battery_charging_full_rounded,
                title: 'شحن بطارية',
                subtitle: 'شحن وتشغيل فوري',
                onTap: () {
                  // TODO: Navigate to battery flow
                },
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: _ServiceCard(
                svgAsset: IconAssets.fuelTruck,
                title: AppStrings.fuelSupply,
                subtitle: AppStrings.fuelSupplyDesc,
                onTap: () {
                  Navigator.pushNamed(context, Routes.fuelType);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String? svgAsset;
  final IconData? icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    this.svgAsset,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const _cardBg = Color(0xFFF2F3F4);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      icon,
                      color: AppColors.primary,
                      size: 28.sp,
                    ),
            ),
            SizedBox(height: Sizes.s16),
            Text(
              title,
              style: getBoldStyle(
                color: AppColors.black,
                fontSize: FontSize.s16,
              ),
            ),
            SizedBox(height: 4.h),
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
    );
  }
}
