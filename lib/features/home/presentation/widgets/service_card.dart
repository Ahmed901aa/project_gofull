import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ServiceCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool flipIcon;

  const ServiceCard({
    super.key,
    required this.svgAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.flipIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        decoration: BoxDecoration(
          color: AppColors.neutral400,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72.w, height: 48.h,
              child: Builder(builder: (ctx) {
                final isRtl = Directionality.of(ctx) == TextDirection.rtl;
                final icon = SvgPicture.asset(svgAsset, fit: BoxFit.contain, colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn));
                return (flipIcon && isRtl) ? Transform.scale(scaleX: -1, child: icon) : icon;
              }),
            ),
            SizedBox(height: Insets.s8),
            Text(title, style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.center),
            SizedBox(height: 2.h),
            Text(subtitle, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
