import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/payment_summary.dart';
import 'package:project_gofull/core/widgets/safety_notice_card.dart';
import 'package:project_gofull/core/widgets/service_bottom_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'package:project_gofull/core/widgets/service_location_card.dart';
import '../widgets/service_section_header.dart';
import '../widgets/towing_car_details_form.dart';

class TowingScreen extends StatefulWidget {
  const TowingScreen({super.key});
  @override
  State<TowingScreen> createState() => _TowingScreenState();
}

class _TowingScreenState extends State<TowingScreen> {
  String? _selectedCarType;
  final _carTypes = ['سيدان', 'SUV', 'بيك أب', 'شاحنة', 'هاتشباك'];
  final _plateCtrl = TextEditingController();

  bool get _isValid => _selectedCarType != null && _plateCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _plateCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
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
                      const ServiceSectionHeader(title: 'مسار الرحلة', gap: 16),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ServiceLocationCard(topLabel: 'نقطة الانطلاق', bottomLabel: 'موقع السيارة الحالي')),
                      const SizedBox(height: 12),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ServiceLocationCard(topLabel: 'وجهة التوصيل', bottomLabel: 'وجهة سحب السيارة')),
                      const ServiceSectionHeader(title: 'تفاصيل السيارة', gap: 16),
                      TowingCarDetailsForm(selectedCarType: _selectedCarType, carTypes: _carTypes, plateCtrl: _plateCtrl, onCarTypeChanged: (v) => setState(() => _selectedCarType = v)),
                      const ServiceSectionHeader(title: 'ملاحظات إضافية', gap: 8),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ServiceInputField(hint: 'ملاحظات إضافية عن حالة السيارة')),
                      const ServiceSectionHeader(title: 'ملخص الدفع', gap: 16),
                      const PaymentSummary(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            ServiceBottomButton(onPressed: _isValid ? () => Navigator.pushNamed(context, Routes.searchingDriver, arguments: const SearchingArgs(
              searchingText: 'جاري البحث عن أقرب سائق ونش',
              subtitleText: 'نقوم الآن بمطابقة طلبك مع أقرب سيارة ونش متاحة في منطقتك.',
              nextRoute: Routes.driverFound,
              nextRouteArgs: DriverFoundArgs(title: 'تم العثور على ونش!', vehicleLabel: 'نوع الونش', vehicleValue: 'ونش هيدروليك', imagePath: 'assets/images/magnifying_glass.gif'),
            )) : null),
          ],
        ),
      ),
    );
  }
}
