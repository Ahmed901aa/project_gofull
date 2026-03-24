import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
      padding: EdgeInsets.fromLTRB(Insets.s16, 0, Insets.s16, Insets.s12),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.grey, size: 20.sp),
            SizedBox(width: Insets.s8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textDirection: TextDirection.rtl,
                style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
                decoration: InputDecoration(
                  hintText: 'ابحث عن موقعك',
                  hintStyle: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (controller.text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, color: AppColors.grey, size: 18.sp),
              ),
          ],
        ),
      ),
    );
  }
}
