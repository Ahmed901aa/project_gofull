import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class FuelServiceDetails extends StatelessWidget {
  final Map<String, String> data;
  const FuelServiceDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('تفاصيل الخدمة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
        SizedBox(height: Insets.s8),
        _row('الكمية الفعلية', data['quantity']!),
        _row('نوع الوقود', data['fuelType']!),
        _row('سعر لتر اليوم', data['pricePerLiter']!),
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
