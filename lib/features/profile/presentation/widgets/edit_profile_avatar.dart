import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class EditProfileAvatar extends StatelessWidget {
  final VoidCallback? onEditTap;

  const EditProfileAvatar({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 104.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 52.w,
              backgroundColor: context.colors.border,
              child: Icon(Icons.person, size: 52.sp, color: context.colors.textSecondary),
            ),
            PositionedDirectional(
              bottom: 0,
              start: 0,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Icon(Icons.edit_outlined, size: 12.sp, color: context.colors.textPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
