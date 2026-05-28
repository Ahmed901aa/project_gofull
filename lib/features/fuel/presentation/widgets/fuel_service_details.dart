import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class FuelServiceDetails extends StatelessWidget {
  final Map<String, String> data;
  const FuelServiceDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.serviceDetails, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.start),
        SizedBox(height: Insets.s8),
        _row(l10n.actualQuantity, data['quantity']!),
        _row(l10n.fuelType, data['fuelType']!),
        _row(l10n.todayPricePerLiter, data['pricePerLiter']!),
      ],
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.s8),
        child: Row(
          children: [
            Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            const Spacer(),
            Text(value, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          ],
        ),
      );
}
