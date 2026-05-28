import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

export 'phone_field.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;

  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.of(context).fullNameLabel,
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
