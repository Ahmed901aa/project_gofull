import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class TripFuelChips extends StatelessWidget {
  final String fuelType;
  final String quantity;

  const TripFuelChips({
    super.key,
    this.fuelType = '—',
    this.quantity = '—',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(
        children: [
          Expanded(child: _Chip(label: 'نوع الوقود', value: fuelType)),
          SizedBox(width: Insets.s16),
          Expanded(child: _Chip(label: 'الكمية المطلوبة', value: quantity)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  const _Chip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBABABA).withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s12)),
          SizedBox(height: 2.h),
          Text(value, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        ],
      ),
    );
  }
}
