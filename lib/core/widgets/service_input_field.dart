import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ServiceInputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  const ServiceInputField({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.start,
          style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getRegularStyle(color: const Color(0xFFAAAAAB), fontSize: FontSize.s14),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }
}
