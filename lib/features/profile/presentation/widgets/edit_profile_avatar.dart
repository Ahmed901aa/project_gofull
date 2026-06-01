import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Read-only circular avatar used on the Profile screen.
class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 52.w,
        backgroundColor: context.colors.primary.withValues(alpha: 0.08),
        child: Icon(
          Icons.person_rounded,
          size: 56.sp,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
