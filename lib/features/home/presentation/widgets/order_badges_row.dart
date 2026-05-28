import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
              color: context.colors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: context.colors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).towServiceLabel, style: getMediumStyle(color: context.colors.primary, fontSize: FontSize.s12)),
                SizedBox(width: 4.w),
                Icon(Icons.local_shipping_outlined, size: 14.sp, color: context.colors.primary),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: context.colors.border),
            ),
            child: Text(S.of(context).inProgressLabel, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s12)),
          ),
        ],
      ),
    );
  }
}
