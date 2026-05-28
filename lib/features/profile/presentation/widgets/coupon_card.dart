import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class CouponCard extends StatelessWidget {
  final String title;
  final String expiry;
  const CouponCard({super.key, required this.title, required this.expiry});

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
            decoration: BoxDecoration(color: AppColors.dots, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(Icons.local_offer_outlined, size: 16.sp, color: AppColors.primary),
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
              Text(expiry, style: getRegularStyle(color: const Color(0xFF121212), fontSize: FontSize.s16).copyWith(fontWeight: FontWeight.w100, height: 1.6)),
            ],
          ),
          const Spacer(),
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.s24)),
            alignment: Alignment.center,
            child: Text(S.of(context).useCoupon, style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s14)),
          ),
        ],
      ),
    );
  }
}
