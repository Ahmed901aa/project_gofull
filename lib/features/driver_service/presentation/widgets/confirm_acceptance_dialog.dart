import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Shows a bottom-sheet confirmation dialog and returns `true` when the user
/// confirms or `false` / `null` when cancelled.
Future<bool?> showConfirmAcceptanceDialog(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    builder: (_) => const _ConfirmAcceptanceContent(),
  );
}

class _ConfirmAcceptanceContent extends StatelessWidget {
  const _ConfirmAcceptanceContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.s24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        Insets.s24,
        Insets.s24,
        Insets.s24,
        Insets.s24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: Insets.s24),

          // Icon
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: context.colors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 32.sp,
              color: context.colors.primary,
            ),
          ),
          SizedBox(height: Insets.s16),

          // Title
          Text(
            S.of(context).confirmAcceptTitle,
            style: getBoldStyle(
              color: context.colors.textPrimary,
              fontSize: FontSize.s20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.s12),

          // Message
          Text(
            S.of(context).confirmAcceptMessage,
            style: getRegularStyle(
              color: context.colors.textSecondary,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.s24),

          // Confirm button
          AppButton(
            text: S.of(context).confirmAccept,
            onPressed: () => Navigator.pop(context, true),
          ),
          SizedBox(height: Insets.s12),

          // Cancel button
          AppButton(
            text: S.of(context).cancel,
            isOutlined: true,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
