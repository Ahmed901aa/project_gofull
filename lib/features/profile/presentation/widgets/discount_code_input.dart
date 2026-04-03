import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DiscountCodeInput extends StatelessWidget {
  final TextEditingController controller;
  const DiscountCodeInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('عندك كود خصم؟', style: getMediumStyle(color: const Color(0xFF121212), fontSize: FontSize.s16).copyWith(height: 1.4)),
        SizedBox(height: Sizes.s8),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          decoration: BoxDecoration(color: AppColors.neutral200, borderRadius: BorderRadius.circular(AppRadius.s16), border: Border.all(color: AppColors.neutral500)),
          alignment: Alignment.centerRight,
          child: TextField(
            controller: controller, textDirection: TextDirection.rtl,
            decoration: InputDecoration(hintText: 'أدخل كود الخصم..', hintStyle: getRegularStyle(color: const Color(0xFFAAAAAB), fontSize: FontSize.s14), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
            style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
          ),
        ),
        SizedBox(height: Insets.s16),
        SizedBox(
          height: 48.h, width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004B3B), foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
            child: Text('تفعيل', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16).copyWith(height: 1.6)),
          ),
        ),
      ],
    );
  }
}
