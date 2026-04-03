import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
              backgroundColor: AppColors.neutral500,
              child: Icon(Icons.person, size: 52.sp, color: const Color(0xFF838485)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                    border: Border.all(color: const Color(0xFFEFF0F1)),
                  ),
                  child: Icon(Icons.edit_outlined, size: 12.sp, color: const Color(0xFF0E0E0E)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
