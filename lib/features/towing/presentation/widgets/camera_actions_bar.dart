import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class CameraActionsBar extends StatelessWidget {
  final VoidCallback onRetake;
  final VoidCallback? onSave;
  final bool saving;

  const CameraActionsBar({
    super.key,
    required this.onRetake,
    required this.onSave,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: context.colors.border.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.all(Insets.s16),
      child: Row(children: [
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: OutlinedButton.icon(
              onPressed: onRetake,
              icon: Icon(Icons.camera_alt_outlined, size: 20.sp, color: context.colors.primary),
              label: Text(S.of(context).retakePhoto, style: getBoldStyle(color: context.colors.primary, fontSize: FontSize.s16)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: context.colors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
            ),
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: ElevatedButton(
              onPressed: saving ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54867C), disabledBackgroundColor: context.colors.border,
                foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0,
              ),
              child: saving
                  ? SizedBox(width: 20.w, height: 20.w, child: CircularProgressIndicator(color: context.colors.surface, strokeWidth: 2))
                  : Text(S.of(context).saveAndContinue, style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s16)),
            ),
          ),
        ),
      ]),
    );
  }
}
