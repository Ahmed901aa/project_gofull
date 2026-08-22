import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class RatingBadge extends StatelessWidget {
  final String rating;
  final String reviewCount;
  const RatingBadge({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star_rounded, color: context.colors.gold, size: 16.sp),
        SizedBox(width: 4.w),
        Text(rating, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
        SizedBox(width: 2.w),
        Text('($reviewCount)', style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14)),
      ]),
    );
  }
}
