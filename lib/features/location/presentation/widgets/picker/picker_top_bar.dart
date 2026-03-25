import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class PickerTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSearchTap;

  const PickerTopBar({
    super.key,
    required this.onBack,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40.w, height: 40.w,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
              ),
              child: Icon(Icons.arrow_back, size: 20.sp, color: AppColors.black),
            ),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: Insets.s12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: AppColors.primary, size: 20.sp),
                    SizedBox(width: Insets.s8),
                    Text('ابحث عن موقع...',
                        style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
