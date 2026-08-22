import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PaymentSummary extends StatelessWidget {
  /// Pass explicit values to override. If null, shows "—".
  final double? subtotal;
  final double? serviceFee;
  final double? total;
  final String? note;

  const PaymentSummary({
    super.key,
    this.subtotal,
    this.serviceFee,
    this.total,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return BlocBuilder<AppConfigBloc, AppConfigState>(
      builder: (context, config) {
        final cur = config.currency;
        final sub = subtotal;
        final fee = serviceFee ?? config.serviceFee;
        final tot = total ?? ((sub ?? 0) + fee);

        final subText = sub != null ? '${sub.toStringAsFixed(2)} $cur' : '—';
        final feeText = '${fee.toStringAsFixed(2)} $cur';
        final totText = tot > 0 ? '${tot.toStringAsFixed(2)} $cur' : '—';

        return Column(
          children: [
            if (note != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Insets.s12),
                  decoration: BoxDecoration(
                    color: context.colors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Text(note!, style: getMediumStyle(color: context.colors.primary, fontSize: FontSize.s14), textAlign: TextAlign.center),
                ),
              ),
            _row(context, label: l10n.subtotal, amount: subText),
            _serviceFeeRow(context, feeText, l10n),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Divider(height: 1, color: context.colors.border),
            ),
            SizedBox(height: Insets.s8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Row(
                children: [
                  Text(l10n.total,
                      style: getRegularStyle(
                          color: context.colors.textSecondary,
                          fontSize: FontSize.s18)),
                  SizedBox(width: Insets.s8),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Insets.s8, vertical: 4.h),
                    decoration: BoxDecoration(
                        color: context.colors.primarySurface,
                        borderRadius: BorderRadius.circular(AppRadius.s16)),
                    child: Text(l10n.cashMethod,
                        style: getRegularStyle(
                            color: context.colors.primary,
                            fontSize: FontSize.s12)),
                  ),
                  const Spacer(),
                  Text(totText,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s18)),
                ],
              ),
            ),
            SizedBox(height: Insets.s8),
          ],
        );
      },
    );
  }

  Widget _row(BuildContext context, {required String label, required String amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(label,
              style: getRegularStyle(
                  color: context.colors.textSecondary, fontSize: FontSize.s16)),
          const Spacer(),
          Text(amount,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16)),
        ],
      ),
    );
  }

  Widget _serviceFeeRow(BuildContext context, String feeText, S l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(l10n.serviceFee,
              style: getRegularStyle(
                  color: context.colors.textSecondary, fontSize: FontSize.s16)),
          const SizedBox(width: 4),
          Icon(Icons.info_outline_rounded, size: 16, color: context.colors.primary),
          const Spacer(),
          Text(feeText,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16)),
        ],
      ),
    );
  }
}
