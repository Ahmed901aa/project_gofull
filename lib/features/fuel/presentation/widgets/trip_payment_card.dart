import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

// replace with API data later
const _subtotal = '940.00 ج.م';
const _fee = '15.00 ج.م';
const _total = '985.00 ج.م';

class TripPaymentCard extends StatelessWidget {
  const TripPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(children: [
        SizedBox(height: Insets.s8),
        _payRow('المجموع', _subtotal),
        _feeRow(),
        const Divider(height: 1, color: AppColors.neutral500),
        SizedBox(height: Insets.s8),
        _totalRow(),
        SizedBox(height: Insets.s8),
      ]),
    );
  }

  Widget _payRow(String label, String amount) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Text(amount, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          const Spacer(),
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
        ]),
      );

  Widget _feeRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Text(_fee, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          const Spacer(),
          Row(children: [
            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text('رسوم الخدمة', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
          ]),
        ]),
      );

  Widget _totalRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        child: Row(children: [
          Text(_total, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
          const Spacer(),
          Row(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppRadius.s16),
              ),
              child: Text('كاش', style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s12)),
            ),
            SizedBox(width: Insets.s8),
            Text('الإجمالي', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s18)),
          ]),
        ]),
      );
}
