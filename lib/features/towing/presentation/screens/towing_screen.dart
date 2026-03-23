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
import 'package:project_gofull/features/towing/presentation/widgets/photo_picker_section.dart';

class TowingScreen extends StatefulWidget {
  const TowingScreen({super.key});
  @override
  State<TowingScreen> createState() => _TowingScreenState();
}

class _TowingScreenState extends State<TowingScreen> {
  String? _selectedCarType;
  final _carTypes = ['سيدان', 'SUV', 'بيك أب', 'شاحنة', 'هاتشباك'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const ServiceHeader(title: 'خدمة ونش'),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SafetyNoticeCard()),
                      _section('مسار الرحلة', gap: 16),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ServiceLocationCard(topLabel: 'نقطة الانطلاق', bottomLabel: 'موقع السيارة الحالي')),
                      const SizedBox(height: 12),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ServiceLocationCard(topLabel: 'وجهة التوصيل', bottomLabel: 'وجهة سحب السيارة')),
                      _section('تفاصيل السيارة', gap: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('نوع السيارة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            ServiceDropdown(hint: 'اختر نوع السيارة', value: _selectedCarType, items: _carTypes, onChanged: (v) => setState(() => _selectedCarType = v)),
                            const SizedBox(height: 12),
                            Text('رقم اللوحة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            const ServiceInputField(hint: 'أدخل رقم اللوحة'),
                            const SizedBox(height: 12),
                            Text('صورة السيارة', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16), textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            const PhotoPickerSection(),
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
