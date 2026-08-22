import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class FuelServiceDetails extends StatelessWidget {
  final Map<String, String> data;
  const FuelServiceDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.serviceDetails, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18), textAlign: TextAlign.start),
        SizedBox(height: Insets.s8),
        _row(context, l10n.actualQuantity, data['quantity']!),
        _row(context, l10n.fuelType, data['fuelType']!),
        _row(context, l10n.todayPricePerLiter, data['pricePerLiter']!),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.s8),
        child: Row(
          children: [
            Text(label, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s16)),
            const Spacer(),
            Text(value, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
          ],
        ),
      );
}
