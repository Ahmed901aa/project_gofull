import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/cubits/location_state.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/payment_summary.dart';
import 'package:project_gofull/core/widgets/safety_notice_card.dart';
import 'package:project_gofull/core/widgets/service_bottom_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'package:project_gofull/core/widgets/service_location_card.dart';
import '../widgets/fuel_details_form.dart';

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

  bool get _isValid => _selectedFuelType != null && _selectedQuantity != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BlocBuilder<LocationCubit, LocationState>(
                          builder: (context, loc) => ServiceLocationCard(
                            topLabel: 'الموقع الحالي',
                            bottomLabel: loc.address,
                            onTap: () => Navigator.pushNamed(context, Routes.locationSearch,
                                arguments: const LocationSearchArgs(title: 'الموقع الحالي')),
                          ),
                        ),
                      ),
                      _section('تفاصيل الوقود', gap: 16),
                      FuelDetailsForm(
                        selectedFuelType: _selectedFuelType,
                        selectedQuantity: _selectedQuantity,
                        fuelTypes: _fuelTypes,
                        quantities: _quantities,
                        onFuelTypeChanged: (v) => setState(() => _selectedFuelType = v),
                        onQuantityChanged: (v) => setState(() => _selectedQuantity = v),
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
            ServiceBottomButton(onPressed: _isValid ? () => Navigator.pushNamed(context, Routes.searchingDriver, arguments: SearchingArgs(
              searchingText: 'جاري البحث عن أقرب مزود وقود',
              subtitleText: 'نقوم الآن بمطابقة طلبك مع أقرب سيارة إمداد مجهزة بنوع الوقود المختار.',
              nextRoute: Routes.driverFound,
              nextRouteArgs: const DriverFoundArgs(title: 'تم العثور على مزود وقود!', vehicleLabel: 'نوع المركبة', vehicleValue: 'سيارة إمداد وقود', showClose: true, imagePath: 'assets/images/tank_truck.gif', nextRoute: Routes.serviceArrived),
            )) : null),
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
