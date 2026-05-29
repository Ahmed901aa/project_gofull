import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class EditProfileBottomButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onDelete;
  final bool saveEnabled;
  final bool saving;

  const EditProfileBottomButtons({
    super.key,
    required this.onSave,
    required this.onDelete,
    this.saveEnabled = true,
    this.saving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        border: Border.all(color: context.colors.inputFill),
        boxShadow: const [
          BoxShadow(color: Color(0x05CCCCCC), blurRadius: 1, offset: Offset(0, -1)),
          BoxShadow(color: Color(0x05CCCCCC), blurRadius: 2, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: saveEnabled ? onSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: context.colors.primary.withValues(alpha: 0.4),
                      disabledForegroundColor: AppColors.white.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                      elevation: 0,
                    ),
                    child: saving
                        ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            S.of(context).saveChanges,
                            style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16).copyWith(height: 1.6),
                          ),
                  ),
                ),
              ),
              SizedBox(width: Insets.s12),
              SizedBox(
                height: 48.h,
                child: OutlinedButton(
                  onPressed: saving ? null : onDelete,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: context.colors.errorSurface,
                    foregroundColor: context.colors.error,
                    side: BorderSide(color: context.colors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                  ),
                  child: Text(
                    S.of(context).deleteAccountBtn,
                    style: getBoldStyle(color: context.colors.error, fontSize: FontSize.s16).copyWith(height: 1.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
