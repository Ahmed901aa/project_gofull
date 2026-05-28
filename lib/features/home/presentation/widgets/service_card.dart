import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
          color: context.isDarkMode
              ? context.colors.surface
              : context.colors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(
            color: context.isDarkMode
                ? context.colors.border.withValues(alpha: 0.6)
                : context.colors.border,
          ),
          boxShadow: context.isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72.w, height: 48.h,
              child: Builder(builder: (ctx) {
                final isRtl = Directionality.of(ctx) == TextDirection.rtl;
                final icon = SvgPicture.asset(svgAsset, fit: BoxFit.contain, colorFilter: ColorFilter.mode(context.colors.primary, BlendMode.srcIn));
                return (flipIcon && isRtl) ? Transform.scale(scaleX: -1, child: icon) : icon;
              }),
            ),
            SizedBox(height: Insets.s8),
            Text(title, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s16), textAlign: TextAlign.center),
            SizedBox(height: 2.h),
            Text(subtitle, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
