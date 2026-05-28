import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Insets.s20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.goldLight, context.isDarkMode ? context.colors.surfaceElevated : const Color(0xFFFDF6EB)],
          begin: AlignmentDirectional.topEnd,
          end: AlignmentDirectional.bottomStart,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(
          color: context.colors.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: context.colors.gold,
              size: 28.sp,
            ),
          ),
          SizedBox(width: Insets.s12),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).subscriptionTitle,
                  style: getSemiBoldStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  S.of(context).subscriptionSubtitle,
                  style: getRegularStyle(
                    color: context.colors.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Insets.s8),
          // CTA button
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.s12,
              vertical: Insets.s8,
            ),
            decoration: BoxDecoration(
              color: context.colors.gold,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Text(
              S.of(context).subscribeNow,
              style: getBoldStyle(
                color: context.colors.surface,
                fontSize: FontSize.s12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
