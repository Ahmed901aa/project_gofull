import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/widgets/service_dropdown.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('نوع الوقود', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
          const SizedBox(height: 8),
          ServiceDropdown(hint: 'اختر نوع الوقود', value: selectedFuelType, items: fuelTypes, onChanged: onFuelTypeChanged),
          const SizedBox(height: 12),
          Text('الكمية المطلوبة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
          const SizedBox(height: 4),
          Text('سيتم إضافة رسوم الخدمة والتوصيل إلى سعر الوقود.', style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.right),
          const SizedBox(height: 8),
          ServiceDropdown(hint: 'اختر الكمية المطلوبة', value: selectedQuantity, items: quantities, onChanged: onQuantityChanged),
        ],
      ),
    );
  }
}
