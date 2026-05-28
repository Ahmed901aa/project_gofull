import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class FuelCompletePaymentSection extends StatelessWidget {
  final Map<String, String> data;
  const FuelCompletePaymentSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.paymentSummary, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18), textAlign: TextAlign.start),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: context.colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            children: [
              SizedBox(height: Insets.s8),
              _payRow(context, l10n.subtotal, data['subtotal']!),
              _serviceFeeRow(context, l10n),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Divider(height: 1, color: context.colors.border),
              ),
              SizedBox(height: Insets.s8),
              _totalRow(context, l10n),
              SizedBox(height: Insets.s8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _payRow(BuildContext context, String label, String amount) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(
          children: [
            Text(label, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s16)),
            const Spacer(),
            Text(amount, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
          ],
        ),
      );

  Widget _serviceFeeRow(BuildContext context, S l10n) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(
          children: [
            Row(children: [
              Text(l10n.serviceFee, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s16)),
              const SizedBox(width: 4),
              Icon(Icons.info_outline_rounded, size: 16, color: context.colors.primary),
            ]),
            const Spacer(),
            Text(data['serviceFee']!, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
          ],
        ),
      );

  Widget _totalRow(BuildContext context, S l10n) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        child: Row(
          children: [
            Row(children: [
              Text(l10n.totalAmount, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s18)),
              SizedBox(width: Insets.s8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
                decoration: BoxDecoration(color: context.colors.primarySurface, borderRadius: BorderRadius.circular(AppRadius.s16)),
                child: Text(l10n.cashPayment, style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s12)),
              ),
            ]),
            const Spacer(),
            Text(data['total']!, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18)),
          ],
        ),
      );
}
