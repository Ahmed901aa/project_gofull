import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'الاسم بالكامل',
          style: getBoldStyle(color: const Color(0xFF252525), fontSize: FontSize.s16).copyWith(height: 1.4),
        ),
        SizedBox(height: Insets.s8),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F9),
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: const Color(0xFFEFF0F1)),
          ),
          alignment: Alignment.centerRight,
          child: TextField(
            controller: controller,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool verified;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVerifyTap;

  const PhoneField({
    super.key,
    required this.controller,
    required this.verified,
    this.onChanged,
    this.onVerifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'رقم الجوال',
          style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16).copyWith(height: 1.4),
        ),
        SizedBox(height: Insets.s8),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F9),
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: const Color(0xFFEFF0F1)),
          ),
          child: Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇱🇾', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(width: Insets.s8),
                  Text(
                    '+218',
                    style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s16).copyWith(height: 1.6),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 16.sp, color: const Color(0xFF838485)),
                ],
              ),
              Container(width: 1, height: 24.h, color: const Color(0xFFD9DADB), margin: EdgeInsets.symmetric(horizontal: 3.w)),
              Expanded(
                child: TextField(
                  controller: controller,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.4),
                  onChanged: onChanged,
                ),
              ),
              SizedBox(width: Insets.s8),
              if (verified)
                Icon(Icons.check_circle, size: 20.sp, color: const Color(0xFF2D6A4F))
              else
                GestureDetector(
                  onTap: onVerifyTap,
                  child: Text(
                    'تأكيد الرقم',
                    style: getBoldStyle(color: const Color(0xFF004B3B), fontSize: FontSize.s14).copyWith(height: 1.6),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
