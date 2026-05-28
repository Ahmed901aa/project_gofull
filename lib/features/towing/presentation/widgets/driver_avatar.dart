import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverAvatar extends StatelessWidget {
  const DriverAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(color: context.colors.surface, shape: BoxShape.circle),
      child: Icon(Icons.person_rounded, color: context.colors.textSecondary, size: 32.sp),
    );
  }
}
