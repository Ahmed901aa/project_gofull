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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s20),
        splashColor: context.colors.primary.withValues(alpha: 0.10),
        highlightColor: context.colors.primary.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: Insets.s16,
            vertical: Insets.s14,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: context.isDarkMode
                  ? [
                      context.colors.surface,
                      context.colors.surface.withValues(alpha: 0.85),
                    ]
                  : [
                      context.colors.surfaceElevated,
                      context.colors.surface,
                    ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.s20),
            border: Border.all(
              color: context.isDarkMode
                  ? context.colors.border.withValues(alpha: 0.6)
                  : context.colors.primary.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: context.isDarkMode
                    ? Colors.black.withValues(alpha: 0.3)
                    : context.colors.primary.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon inside a soft circular halo for visual lift
              Container(
                width: 80.w,
                height: 64.h,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                ),
                child: Builder(builder: (ctx) {
                  final isRtl = Directionality.of(ctx) == TextDirection.rtl;
                  final icon = SvgPicture.asset(
                    svgAsset,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                        context.colors.primary, BlendMode.srcIn),
                  );
                  return (flipIcon && isRtl)
                      ? Transform.scale(scaleX: -1, child: icon)
                      : icon;
                }),
              ),
              SizedBox(height: Insets.s10),
              Text(
                title,
                style: getSemiBoldStyle(
                    color: context.colors.textPrimary, fontSize: FontSize.s15),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: getRegularStyle(
                    color: context.colors.textSecondary, fontSize: FontSize.s12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
