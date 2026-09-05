import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
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

  /// Mirrors the tow-form behaviour: flip to `true` on submit attempt to
  /// reveal inline validation messages for empty dropdowns.
  final bool showValidation;

  const FuelDetailsForm({
    super.key,
    required this.selectedFuelType,
    required this.selectedQuantity,
    required this.fuelTypes,
    required this.quantities,
    required this.onFuelTypeChanged,
    required this.onQuantityChanged,
    this.showValidation = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final fuelError = showValidation &&
            (selectedFuelType == null || selectedFuelType!.isEmpty)
        ? l10n.pleaseSelectFuelType
        : null;
    final qtyError = showValidation &&
            (selectedQuantity == null || selectedQuantity!.isEmpty)
        ? l10n.pleaseSelectQuantity
        : null;

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ServiceDropdown(
            label: l10n.fuelTypeFieldLabel,
            helper: l10n.fuelTypeFieldHelper,
            hint: l10n.fuelTypeFieldHint,
            prefixIcon: Icons.local_gas_station_rounded,
            value: selectedFuelType,
            items: fuelTypes,
            onChanged: onFuelTypeChanged,
            errorText: fuelError,
          ),
          SizedBox(height: Sizes.s16),
          ServiceDropdown(
            label: l10n.quantityFieldLabel,
            helper: l10n.quantityFieldHelper,
            hint: l10n.quantityFieldHint,
            prefixIcon: Icons.water_drop_rounded,
            value: selectedQuantity,
            items: quantities,
            onChanged: onQuantityChanged,
            errorText: qtyError,
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 13.sp, color: context.colors.textSecondary),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  l10n.serviceFeeDeliveryNote,
                  style: getRegularStyle(
                    color: context.colors.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
