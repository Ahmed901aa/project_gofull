import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class PhotoPickerSection extends StatelessWidget {
  const PhotoPickerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _slot(child: Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 32.sp)),
        SizedBox(width: Insets.s16),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _slot(child: Icon(Icons.directions_car_outlined, color: AppColors.neutral900, size: 32.sp)),
              Positioned(
                top: -8.h,
                right: -8.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.s16)),
                  child: Icon(Icons.edit_outlined, color: AppColors.white, size: 12.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: Insets.s16),
        _slot(child: Icon(Icons.image_outlined, color: AppColors.neutral800, size: 32.sp)),
      ],
    );
  }

  Widget _slot({required Widget child}) {
    return Expanded(
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFF0F1)),
        ),
        child: Center(child: child),
      ),
    );
  }
}
