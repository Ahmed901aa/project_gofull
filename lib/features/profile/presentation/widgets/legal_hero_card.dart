import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Compact hero card shown at the top of legal screens (Privacy Policy,
/// Terms). Single horizontal row: white logo card + title + last-updated.
class LegalHeroCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String lastUpdated;

  const LegalHeroCard({
    super.key,
    required this.icon,
    required this.title,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Insets.s14,
        vertical: Insets.s12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            context.colors.primary,
            context.colors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo badge
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: Insets.s10,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.s12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SvgPicture.asset(
              SvgAssets.logo,
              height: 18.h,
              colorFilter: ColorFilter.mode(
                context.colors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: Insets.s12),

          // Title + last updated
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 14.sp, color: Colors.white),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        title,
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 11.sp,
                        color: Colors.white.withValues(alpha: 0.85)),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        lastUpdated,
                        style: getRegularStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: FontSize.s11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
