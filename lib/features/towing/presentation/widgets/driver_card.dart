import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DriverCard extends StatelessWidget {
  const DriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
        boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.1), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Car info — LEFT (last in RTL)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تويوتا هايلكس - أبيض', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s12)),
                    Text('⭐ 4.8', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
                  ],
                ),
              ),
              // Driver info — RIGHT (first in RTL)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 48.w, height: 48.w,
                    decoration: BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
                    child: Icon(Icons.person_rounded, color: AppColors.primary, size: 28.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text('أحمد محمد', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
                ],
              ),
            ],
          ),
          SizedBox(height: Insets.s12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Insets.s8),
            decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(AppRadius.s16)),
            child: Text('وصول خلال 8 دقائق', style: getMediumStyle(color: AppColors.primary, fontSize: FontSize.s14), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
