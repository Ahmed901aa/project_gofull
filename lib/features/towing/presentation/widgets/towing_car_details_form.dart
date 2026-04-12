import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'photo_picker_section.dart';

class TowingCarDetailsForm extends StatelessWidget {
  final TextEditingController carTypeCtrl;
  final TextEditingController plateCtrl;

  const TowingCarDetailsForm({
    super.key,
    required this.carTypeCtrl,
    required this.plateCtrl,
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
          ServiceInputField(hint: 'أدخل نوع السيارة', controller: carTypeCtrl),
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
