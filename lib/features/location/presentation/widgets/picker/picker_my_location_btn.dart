import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';

class PickerMyLocationBtn extends StatelessWidget {
  final VoidCallback onTap;
  const PickerMyLocationBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Icon(Icons.my_location_rounded, color: AppColors.primary, size: 22.sp),
      ),
    );
  }
}
