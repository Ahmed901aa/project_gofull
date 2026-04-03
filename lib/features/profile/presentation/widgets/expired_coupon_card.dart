import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ExpiredCouponCard extends StatelessWidget {
  final String title;
  final String expiry;
  const ExpiredCouponCard({super.key, required this.title, required this.expiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79.h,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(color: AppColors.neutral500, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(Icons.local_offer_outlined, size: 16.sp, color: AppColors.neutral900),
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
              Text(expiry, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16).copyWith(fontWeight: FontWeight.w100, height: 1.6)),
            ],
          ),
        ],
      ),
    );
  }
}
