import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.s24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row — Greeting + Notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Greeting
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppStrings.welcomePrefix} $userName',
                    style: getBoldStyle(
                      color: AppColors.white,
                      fontSize: FontSize.s20,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    AppStrings.welcomeSubtitle,
                    style: getRegularStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
              ),
              // Notification bell
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.white,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Sizes.s12),

          // Search bar
          GestureDetector(
            onTap: () {
              // TODO: Open search screen
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.s16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.grey,
                    size: 20.sp,
                  ),
                  SizedBox(width: Insets.s8),
                  Text(
                    'ابحث عن الخدمة المطلوبة',
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
