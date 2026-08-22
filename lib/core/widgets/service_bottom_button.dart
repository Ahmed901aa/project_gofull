import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ServiceBottomButton extends StatelessWidget {
  final String? label;

  /// Called when the button is tapped AND [isEnabled] is true.
  final VoidCallback? onPressed;

  /// Called when the button is tapped while [isEnabled] is false.
  /// Use this to show a validation error message.
  final VoidCallback? onDisabledTap;

  final bool isLoading;
  final bool isEnabled;

  const ServiceBottomButton({
    super.key,
    this.label,
    this.onPressed,
    this.onDisabledTap,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: context.colors.border.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
      child: SizedBox(
        height: 48.h,
        width: double.infinity,
        // GestureDetector catches taps on the disabled button to show validation errors
        child: GestureDetector(
          onTap: (!isEnabled && !isLoading) ? onDisabledTap : null,
          child: ElevatedButton(
            // Truly disabled when loading OR when not enabled
            onPressed: (isLoading || !isEnabled) ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              disabledBackgroundColor: context.colors.border,
              foregroundColor: AppColors.white,
              disabledForegroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: context.colors.surface))
                : Text(label ?? S.of(context).confirm, style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s16)),
          ),
        ),
      ),
    );
  }
}
