import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

/// Search input: bg #F8F8F9, border #EFF0F1, radius 16px, height 48px.
/// RTL Row: search icon (right) | text field | X clear (left).
class LocationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;

  const LocationSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s8, Insets.s16, Insets.s8),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Row(
          children: [
            // RTL first child → rightmost = search icon
            Icon(Icons.search_rounded, color: AppColors.neutral800, size: 20.sp),
            SizedBox(width: Insets.s8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textDirection: TextDirection.rtl,
                style: getMediumStyle(
                    color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                decoration: InputDecoration(
                  hintText: 'ابحث عن موقعك',
                  hintStyle: getRegularStyle(
                      color: AppColors.neutral800, fontSize: FontSize.s16),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            // RTL last child → leftmost = X clear button
            if (controller.text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.close, color: AppColors.neutral800, size: 18.sp),
              ),
          ],
        ),
      ),
    );
  }
}
