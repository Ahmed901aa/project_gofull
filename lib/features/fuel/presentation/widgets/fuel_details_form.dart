import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/widgets/service_dropdown.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class FuelDetailsForm extends StatelessWidget {
  final String? selectedFuelType;
  final String? selectedQuantity;
  final List<String> fuelTypes;
  final List<String> quantities;
  final ValueChanged<String?> onFuelTypeChanged;
  final ValueChanged<String?> onQuantityChanged;

  const FuelDetailsForm({
    super.key,
    required this.selectedFuelType,
    required this.selectedQuantity,
    required this.fuelTypes,
    required this.quantities,
    required this.onFuelTypeChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.fuelType, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s16), textAlign: TextAlign.start),
          const SizedBox(height: 8),
          ServiceDropdown(hint: l10n.selectFuelTypeHint, value: selectedFuelType, items: fuelTypes, onChanged: onFuelTypeChanged),
          const SizedBox(height: 12),
          Text(l10n.requestedQuantity, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s16), textAlign: TextAlign.start),
          const SizedBox(height: 4),
          Text(l10n.serviceFeeDeliveryNote, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14), textAlign: TextAlign.start),
          const SizedBox(height: 8),
          ServiceDropdown(hint: l10n.selectQuantityHint, value: selectedQuantity, items: quantities, onChanged: onQuantityChanged),
        ],
      ),
    );
  }
}
