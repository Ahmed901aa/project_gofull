import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/widgets/service_dropdown.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'photo_picker_section.dart';

class TowingCarDetailsForm extends StatelessWidget {
  final String? selectedCarType;
  final List<String> carTypes;
  final TextEditingController plateCtrl;
  final ValueChanged<String?> onCarTypeChanged;

  const TowingCarDetailsForm({
    super.key,
    required this.selectedCarType,
    required this.carTypes,
    required this.plateCtrl,
    required this.onCarTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('نوع السيارة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
          const SizedBox(height: 8),
          ServiceDropdown(hint: 'اختر نوع السيارة', value: selectedCarType, items: carTypes, onChanged: onCarTypeChanged),
          const SizedBox(height: 12),
          Text('رقم اللوحة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
          const SizedBox(height: 8),
          ServiceInputField(hint: 'أدخل رقم اللوحة', controller: plateCtrl),
          const SizedBox(height: 12),
          Text('صورة السيارة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
          const SizedBox(height: 8),
          const PhotoPickerSection(),
        ],
      ),
    );
  }
}
