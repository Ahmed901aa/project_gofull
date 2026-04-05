import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';

class PaymentSummary extends StatelessWidget {
  /// Pass explicit values to override. If null, shows "—".
  final double? subtotal;
  final double? serviceFee;
  final double? total;

  const PaymentSummary({
    super.key,
    this.subtotal,
    this.serviceFee,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
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
            _row(label: 'المجموع', amount: subText),
            _serviceFeeRow(feeText),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: const Divider(height: 1, color: Color(0xFFEFF0F1)),
            ),
            SizedBox(height: Insets.s8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Row(
                children: [
                  Text('الإجمالي',
                      style: getRegularStyle(
                          color: AppColors.neutral900,
                          fontSize: FontSize.s18)),
                  SizedBox(width: Insets.s8),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Insets.s8, vertical: 4.h),
                    decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(AppRadius.s16)),
                    child: Text('كاش',
                        style: getRegularStyle(
                            color: AppColors.primary,
                            fontSize: FontSize.s12)),
                  ),
                  const Spacer(),
                  Text(totText,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
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

  Widget _row({required String label, required String amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(label,
              style: getRegularStyle(
                  color: AppColors.neutral900, fontSize: FontSize.s16)),
          const Spacer(),
          Text(amount,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ],
      ),
    );
  }

  Widget _serviceFeeRow(String feeText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text('رسوم الخدمة',
              style: getRegularStyle(
                  color: AppColors.neutral900, fontSize: FontSize.s16)),
          const SizedBox(width: 4),
          Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          const Spacer(),
          Text(feeText,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ],
      ),
    );
  }
}
