import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/payment_summary.dart';
import 'package:project_gofull/core/widgets/safety_notice_card.dart';
import 'package:project_gofull/core/widgets/service_bottom_button.dart';
import 'package:project_gofull/core/widgets/service_dropdown.dart';
import 'package:project_gofull/core/widgets/service_header.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'package:project_gofull/core/widgets/service_location_card.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});
  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  String? _selectedFuelType;
  String? _selectedQuantity;
  final _fuelTypes = ['بنزين 91', 'بنزين 95', 'ديزل'];
  final _quantities = ['20 لتر', '30 لتر', '40 لتر', '50 لتر'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const ServiceHeader(title: 'إمداد وقود'),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SafetyNoticeCard()),
                      _section('الموقع', gap: 16),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ServiceLocationCard(topLabel: 'الموقع الحالي', bottomLabel: 'موقع السيارة الحالي')),
                      _section('تفاصيل الوقود', gap: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('نوع الوقود', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            ServiceDropdown(hint: 'اختر نوع الوقود', value: _selectedFuelType, items: _fuelTypes, onChanged: (v) => setState(() => _selectedFuelType = v)),
                            const SizedBox(height: 12),
                            Text('الكمية المطلوبة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
                            const SizedBox(height: 4),
                            Text('سيتم إضافة رسوم الخدمة والتوصيل إلى سعر الوقود.', style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            ServiceDropdown(hint: 'اختر الكمية المطلوبة', value: _selectedQuantity, items: _quantities, onChanged: (v) => setState(() => _selectedQuantity = v)),
                          ],
                        ),
                      ),
                      _section('ملاحظات إضافية', gap: 8),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ServiceInputField(hint: 'ملاحظات إضافية عن حالة السيارة')),
                      _section('ملخص الدفع', gap: 16),
                      const PaymentSummary(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            const ServiceBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, {required double gap}) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
      ),
      SizedBox(height: gap),
    ],
  );
}
