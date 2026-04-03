import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DialogActionButtons extends StatelessWidget {
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const DialogActionButtons({
    super.key,
    required this.cancelLabel,
    required this.confirmLabel,
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onCancel ?? () => Navigator.pop(context, false),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.s24)),
              alignment: Alignment.center,
              child: Text(cancelLabel, style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
            ),
          ),
        ),
        SizedBox(width: Insets.s16),
        Expanded(
          child: GestureDetector(
            onTap: onConfirm ?? () => Navigator.pop(context, true),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE1E3),
                borderRadius: BorderRadius.circular(AppRadius.s24),
                border: Border.all(color: const Color(0xFFE63946), width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(confirmLabel, style: getBoldStyle(color: const Color(0xFFE63946), fontSize: FontSize.s16)),
            ),
          ),
        ),
      ],
    );
  }
}
