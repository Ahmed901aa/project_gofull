import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'dialog_action_buttons.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? context.colors.primary;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: Insets.s24),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 12.h),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.s24),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 80.w, height: 80.w,
                decoration: BoxDecoration(color: resolvedIconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 40.sp, color: resolvedIconColor),
              ),
              SizedBox(height: 8.h),
              Text(title, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20), textAlign: TextAlign.center),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(subtitle, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14), textAlign: TextAlign.center),
              ),
              SizedBox(height: 12.h),
              DialogActionButtons(cancelLabel: cancelLabel, confirmLabel: confirmLabel, onCancel: onCancel, onConfirm: onConfirm),
            ],
          ),
        ),
      );
  }
}
