import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'dialog_action_buttons.dart';

class ConfirmationDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.icon,
    this.iconColor = const Color(0xFF004B3B),
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    this.cancelLabel = 'إلغاء',
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: Insets.s24),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(AppRadius.s24),
            border: Border.all(color: const Color(0xFFEFF0F1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 80.w, height: 80.w,
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 40.sp, color: iconColor),
              ),
              SizedBox(height: 8.h),
              Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20), textAlign: TextAlign.center),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(subtitle, style: getRegularStyle(color: const Color(0xFF646565), fontSize: FontSize.s14), textAlign: TextAlign.center),
              ),
              SizedBox(height: 12.h),
              DialogActionButtons(cancelLabel: cancelLabel, confirmLabel: confirmLabel, onCancel: onCancel, onConfirm: onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
