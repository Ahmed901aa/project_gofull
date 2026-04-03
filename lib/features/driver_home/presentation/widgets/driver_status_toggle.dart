import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DriverStatusToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const DriverStatusToggle({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isActive),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s12,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.s24),
          border: Border.all(
            color: isActive
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.success : AppColors.error,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              isActive ? AppStrings.active : AppStrings.inactive,
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: isActive ? AppColors.success : AppColors.error,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.sp,
              color: isActive ? AppColors.success : AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
