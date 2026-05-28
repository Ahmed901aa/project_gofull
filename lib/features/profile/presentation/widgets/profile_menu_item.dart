import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
          color: context.colors.background,
          borderRadius: BorderRadius.circular(AppRadius.s24),
          border: Border.all(color: context.colors.border),
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
                    color: context.colors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.border),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 16.sp, color: iconColor ?? context.colors.textPrimary),
                ),
                SizedBox(width: Insets.s8),
                Text(
                  label,
                  style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s16),
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
                    style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14),
                  ),
                  SizedBox(width: Insets.s8),
                ],
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_back_ios_rounded
                      : Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: context.colors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
