import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
        decoration: BoxDecoration(
          color: context.colors.surface,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Icon(Icons.my_location_rounded, color: context.colors.primary, size: 22.sp),
      ),
    );
  }
}
