import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/cubits/location_state.dart';
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
  String _destinationAddress = 'وجهة سحب السيارة';
  double? _destinationLat;
  double? _destinationLng;

  bool get _isValid => _selectedCarType != null && _plateCtrl.text.trim().isNotEmpty;

  Future<void> _onDestinationTap() async {
    final cubit = context.read<LocationCubit>();
    final prev = cubit.state;
    await Navigator.pushNamed(context, Routes.locationSearch,
        arguments: const LocationSearchArgs(title: 'وجهة التوصيل'));
    if (!mounted) return;
    final selected = cubit.state;
    if (selected.address != prev.address) {
      setState(() {
        _destinationAddress = selected.address;
        _destinationLat = selected.lat;
        _destinationLng = selected.lng;
      });
      if (prev.lat != null) {
        cubit.setLocation(prev.address, prev.lat!, prev.lng!);
      }
    }
  }

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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BlocBuilder<LocationCubit, LocationState>(
                          builder: (context, loc) => ServiceLocationCard(
                            topLabel: 'نقطة الانطلاق',
                            bottomLabel: loc.address,
                            onTap: () => Navigator.pushNamed(context, Routes.locationSearch,
                                arguments: const LocationSearchArgs(title: 'الموقع الحالي')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ServiceLocationCard(
                          topLabel: 'وجهة التوصيل',
                          bottomLabel: _destinationAddress,
                          onTap: _onDestinationTap,
                        ),
                      ),
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
            ServiceBottomButton(onPressed: _isValid ? () {
              final loc = context.read<LocationCubit>().state;
              final tripArgs = TripInProgressArgs(
                originAddress: loc.address,
                destinationAddress: _destinationAddress,
                originLat: loc.lat,
                originLng: loc.lng,
                destinationLat: _destinationLat,
                destinationLng: _destinationLng,
              );
              Navigator.pushNamed(context, Routes.searchingDriver, arguments: SearchingArgs(
                searchingText: 'جاري البحث عن أقرب سائق ونش',
                subtitleText: 'نقوم الآن بمطابقة طلبك مع أقرب سيارة ونش متاحة في منطقتك.',
                nextRoute: Routes.driverFound,
                nextRouteArgs: DriverFoundArgs(
                  title: 'تم العثور على ونش!',
                  vehicleLabel: 'نوع الونش',
                  vehicleValue: 'ونش هيدروليك',
                  imagePath: 'assets/images/magnifying_glass.gif',
                  nextRoute: Routes.towingStarted,
                  nextRouteArgs: TowingStartedArgs(nextRouteArgs: tripArgs),
                ),
              ));
            } : null),
          ],
        ),
      ),
    );
  }
}
