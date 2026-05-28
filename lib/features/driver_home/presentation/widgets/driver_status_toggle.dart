import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DriverStatusToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onChanged;

  const DriverStatusToggle({
    super.key,
    required this.isActive,
    this.onChanged,
  });

  bool get _locked => onChanged == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _locked ? null : () => onChanged!(!isActive),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.success.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isActive
                ? AppColors.success.withValues(alpha: 0.3)
                : const Color(0xFFe5e7eb),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColors.success.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.success : const Color(0xFF9ca3af),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              isActive ? S.of(context).active : S.of(context).inactive,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: isActive ? AppColors.success : const Color(0xFF6b7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
