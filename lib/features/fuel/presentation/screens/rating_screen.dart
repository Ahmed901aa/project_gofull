import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

// TODO: Build the full rating screen UI — this is a placeholder.
class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Text(
                    'تقييم الخدمة',
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 64.sp, color: AppColors.gold),
                    SizedBox(height: Insets.s16),
                    Text(
                      'شاشة التقييم قيد الإنشاء',
                      style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'سيتم إضافة نظام التقييم قريباً.',
                      style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
