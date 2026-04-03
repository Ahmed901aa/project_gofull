import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class FuelCompletePaymentSection extends StatelessWidget {
  final Map<String, String> data;
  const FuelCompletePaymentSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('ملخص الدفع', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutral400,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Column(
            children: [
              SizedBox(height: Insets.s8),
              _payRow('المجموع', data['subtotal']!),
              _serviceFeeRow(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: const Divider(height: 1, color: AppColors.neutral600),
              ),
              SizedBox(height: Insets.s8),
              _totalRow(),
              SizedBox(height: Insets.s8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _payRow(String label, String amount) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(
          children: [
            Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            const Spacer(),
            Text(amount, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          ],
        ),
      );

  Widget _serviceFeeRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(
          children: [
            Row(children: [
              Text('رسوم الخدمة', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
              const SizedBox(width: 4),
              Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
            ]),
            const Spacer(),
            Text(data['serviceFee']!, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          ],
        ),
      );

  Widget _totalRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        child: Row(
          children: [
            Row(children: [
              Text('الإجمالي', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s18)),
              SizedBox(width: Insets.s8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
                decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(AppRadius.s16)),
                child: Text('كاش', style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s12)),
              ),
            ]),
            const Spacer(),
            Text(data['total']!, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
          ],
        ),
      );
}
