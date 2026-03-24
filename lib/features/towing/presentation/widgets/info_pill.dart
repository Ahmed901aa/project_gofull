import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(children: [
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s12)),
          SizedBox(height: 2.h),
          Text(value, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        ]),
      ),
    );
  }
}
