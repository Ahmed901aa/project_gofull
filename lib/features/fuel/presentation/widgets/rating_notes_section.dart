import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class RatingNotesSection extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final VoidCallback onChanged;

  const RatingNotesSection({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('أضف ملاحظاتك', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.start),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: 4,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            decoration: InputDecoration(
              hintText: 'اكتب هنا أي تفاصيل إضافية تود مشاركتها...',
              hintStyle: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
              contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
        SizedBox(height: 4.h),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.s8),
            child: Text(
              '${controller.text.length}/$maxLength',
              style: getMediumStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ],
    );
  }
}
