import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class RatingBadge extends StatelessWidget {
  final String rating;
  final String reviewCount;
  const RatingBadge({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 16.sp),
        SizedBox(width: 4.w),
        Text(rating, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        SizedBox(width: 2.w),
        Text('($reviewCount)', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
      ]),
    );
  }
}
