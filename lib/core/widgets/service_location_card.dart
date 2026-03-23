import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ServiceLocationCard extends StatelessWidget {
  final String topLabel;
  final String bottomLabel;
  const ServiceLocationCard({super.key, required this.topLabel, required this.bottomLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F6),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFD9DADB)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(AppRadius.s16)),
            child: Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16.sp),
          ),
          SizedBox(width: Insets.s8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(topLabel, style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s12)),
              SizedBox(height: 3.h),
              Text(bottomLabel, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: const Color(0xFF0E0E0E)),
        ],
      ),
    );
  }
}
