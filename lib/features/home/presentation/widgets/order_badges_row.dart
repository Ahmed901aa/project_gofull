import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class OrderBadgesRow extends StatelessWidget {
  const OrderBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('خدمة ساحبة', style: getMediumStyle(color: AppColors.primary, fontSize: FontSize.s12)),
                SizedBox(width: 4.w),
                Icon(Icons.local_shipping_outlined, size: 14.sp, color: AppColors.primary),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.neutral500,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral600),
            ),
            child: Text('قيد التنفيذ', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s12)),
          ),
        ],
      ),
    );
  }
}
