import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ServiceLocationCard extends StatelessWidget {
  final String topLabel;
  final String bottomLabel;
  final VoidCallback? onTap;
  const ServiceLocationCard({super.key, required this.topLabel, required this.bottomLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(color: context.colors.primarySurface, borderRadius: BorderRadius.circular(AppRadius.s16)),
            child: Icon(Icons.location_on_outlined, color: context.colors.primary, size: 16.sp),
          ),
          SizedBox(width: Insets.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(topLabel, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12)),
                SizedBox(height: 3.h),
                Text(bottomLabel, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_rounded, size: 16.sp, color: context.colors.textPrimary),
        ],
      ),
    ));
  }
}
