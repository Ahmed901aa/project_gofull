import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';

class DriverAvatar extends StatelessWidget {
  const DriverAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
      child: Icon(Icons.person_rounded, color: AppColors.neutral800, size: 32.sp),
    );
  }
}
