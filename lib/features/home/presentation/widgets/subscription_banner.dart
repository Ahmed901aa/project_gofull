import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Insets.s20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5E6C5), Color(0xFFFDF6EB)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.gold,
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
                  AppStrings.subscriptionTitle,
                  style: getSemiBoldStyle(
                    color: AppColors.black,
                    fontSize: FontSize.s14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.subscriptionSubtitle,
                  style: getRegularStyle(
                    color: AppColors.darkGrey,
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
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Text(
              AppStrings.subscribeNow,
              style: getBoldStyle(
                color: AppColors.white,
                fontSize: FontSize.s12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
