import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class TripPaymentSection extends StatelessWidget {
  final String subtotal;
  final String serviceFee;
  final String total;

  const TripPaymentSection({
    super.key,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.of(context).paymentSummary,
          style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: context.colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(children: [
            SizedBox(height: Insets.s8),
            _payRow(context, S.of(context).subtotal, subtotal),
            _serviceFeeRow(context),
            Divider(height: 1, color: context.colors.border),
            SizedBox(height: Insets.s8),
            _totalRow(context),
            SizedBox(height: Insets.s8),
          ]),
        ),
      ],
    );
  }

  Widget _payRow(BuildContext context, String label, String amount) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Text(label, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s16)),
          const Spacer(),
          Text(amount, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
        ]),
      );

  Widget _serviceFeeRow(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Row(children: [
            Text(S.of(context).serviceFee, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s16)),
            const SizedBox(width: 4),
            Icon(Icons.info_outline_rounded, size: 16, color: context.colors.primary),
          ]),
          const Spacer(),
          Text(serviceFee, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
        ]),
      );

  Widget _totalRow(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        child: Row(children: [
          Row(children: [
            Text(S.of(context).totalAmount, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s18)),
            SizedBox(width: Insets.s8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
              decoration: BoxDecoration(
                color: context.colors.primarySurface,
                borderRadius: BorderRadius.circular(AppRadius.s16),
              ),
              child: Text(S.of(context).cashPayment, style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s12)),
            ),
          ]),
          const Spacer(),
          Text(total, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18)),
        ]),
      );
}
