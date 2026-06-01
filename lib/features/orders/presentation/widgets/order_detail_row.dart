import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14),
          ),
          SizedBox(width: Insets.s8),
          Text(
            value,
            style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
          ),
        ],
      ),
    );
  }
}
