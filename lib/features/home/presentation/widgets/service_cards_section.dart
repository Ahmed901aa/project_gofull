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
    return Row(
      children: [
        Expanded(
          child: _ServiceCard(
            svgAsset: IconAssets.fuelTruck,
            title: AppStrings.fuelSupply,
            subtitle: AppStrings.fuelSupplyDesc,
            onTap: () => Navigator.pushNamed(context, Routes.fuelType),
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: _ServiceCard(
            svgAsset: IconAssets.towTruck,
            title: AppStrings.towTruckService,
            subtitle: AppStrings.towTruckServiceDesc,
            onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s8,
        ),
        decoration: BoxDecoration(
          color: AppColors.neutral400,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72.w,
              height: 48.h,
              child: SvgPicture.asset(
                svgAsset,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: Insets.s8),
            Text(
              title,
              style: getMediumStyle(
                color: const Color(0xFF0E0E0E),
                fontSize: FontSize.s16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: getRegularStyle(
                color: AppColors.neutral900,
                fontSize: FontSize.s12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
