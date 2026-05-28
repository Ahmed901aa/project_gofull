import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class ServiceBottomButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  const ServiceBottomButton({
    super.key,
    this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
      child: SizedBox(
        height: 48.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppColors.primary : const Color(0xFFD9DADB),
            disabledBackgroundColor: const Color(0xFFD9DADB),
            foregroundColor: AppColors.white,
            disabledForegroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.white))
              : Text(label ?? S.of(context).confirm, style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
        ),
      ),
    );
  }
}
