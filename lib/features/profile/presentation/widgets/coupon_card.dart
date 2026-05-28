import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
        color: context.colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(color: context.colors.iconSecondary, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(Icons.local_offer_outlined, size: 16.sp, color: context.colors.primary),
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18)),
              Text(expiry, style: getRegularStyle(color: const Color(0xFF121212), fontSize: FontSize.s16).copyWith(fontWeight: FontWeight.w100, height: 1.6)),
            ],
          ),
          const Spacer(),
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            decoration: BoxDecoration(color: context.colors.primary, borderRadius: BorderRadius.circular(AppRadius.s24)),
            alignment: Alignment.center,
            child: Text(S.of(context).useCoupon, style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s14)),
          ),
        ],
      ),
    );
  }
}
