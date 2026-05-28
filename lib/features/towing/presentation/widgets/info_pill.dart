import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class InfoPill extends StatelessWidget {
  final String label;
  final String value;
  const InfoPill({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(children: [
          Text(label, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12)),
          SizedBox(height: 2.h),
          Text(value, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
        ]),
      ),
    );
  }
}
