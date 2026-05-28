import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppRadius.s24),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // RIGHT side: icon + label
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.neutral500),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 16.sp, color: iconColor ?? const Color(0xFF0E0E0E)),
                ),
                SizedBox(width: Insets.s8),
                Text(
                  label,
                  style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                ),
              ],
            ),
            // LEFT side: trailing text + arrow
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (trailing != null) ...[
                  Text(
                    trailing!,
                    style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
                  ),
                  SizedBox(width: Insets.s8),
                ],
                Icon(Icons.arrow_forward_rounded, size: 16.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
