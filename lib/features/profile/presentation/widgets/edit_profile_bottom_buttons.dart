import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class EditProfileBottomButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const EditProfileBottomButtons({
    super.key,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        border: Border.all(color: const Color(0xFFF8F8F9)),
        boxShadow: const [
          BoxShadow(color: Color(0x05CCCCCC), blurRadius: 1, offset: Offset(0, -1)),
          BoxShadow(color: Color(0x05CCCCCC), blurRadius: 2, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004B3B),
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                      elevation: 0,
                    ),
                    child: Text(
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
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBE1E3),
                    foregroundColor: const Color(0xFFE63946),
                    side: const BorderSide(color: Color(0xFFE63946)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                  ),
                  child: Text(
                    S.of(context).deleteAccountBtn,
                    style: getBoldStyle(color: const Color(0xFFE63946), fontSize: FontSize.s16).copyWith(height: 1.6),
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
