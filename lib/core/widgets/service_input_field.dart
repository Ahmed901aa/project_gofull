import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
        color: context.colors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.start,
        style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: getRegularStyle(color: context.colors.textDisabled, fontSize: FontSize.s14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
