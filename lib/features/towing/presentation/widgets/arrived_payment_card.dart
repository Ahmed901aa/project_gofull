import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class ArrivedPaymentCard extends StatelessWidget {
  final String subtotal;
  final String serviceFee;
  final String total;

  const ArrivedPaymentCard({
    super.key,
    this.subtotal = '—',
    this.serviceFee = '—',
    this.total = '—',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.of(context).paymentSummary, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutral400,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Column(children: [
            SizedBox(height: Insets.s8),
            _payRow(S.of(context).subtotal, subtotal),
            _serviceFeeRow(context),
            const Divider(height: 1, color: AppColors.neutral500),
            SizedBox(height: Insets.s8),
            _totalRow(context),
            SizedBox(height: Insets.s8),
          ]),
        ),
      ],
    );
  }

  Widget _payRow(String label, String amount) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
          const Spacer(),
          Text(amount, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ]),
      );

  Widget _serviceFeeRow(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Row(children: [
            Text(S.of(context).serviceFee, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            const SizedBox(width: 4),
            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          ]),
          const Spacer(),
          Text(serviceFee, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ]),
      );

  Widget _totalRow(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        child: Row(children: [
          Row(children: [
            Text(S.of(context).totalAmount, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s18)),
            SizedBox(width: Insets.s8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
              decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(AppRadius.s16)),
              child: Text(S.of(context).cashPayment, style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s12)),
            ),
          ]),
          const Spacer(),
          Text(total, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        ]),
      );
}
