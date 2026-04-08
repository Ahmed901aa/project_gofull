import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/payment_summary.dart';
import 'package:project_gofull/core/widgets/safety_notice_card.dart';
import 'package:project_gofull/core/widgets/service_bottom_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import '../widgets/service_section_header.dart';
import '../widgets/towing_car_details_form.dart';
import '../widgets/towing_route_section.dart';

class TowingScreen extends StatefulWidget {
  const TowingScreen({super.key});
  @override
  State<TowingScreen> createState() => _TowingScreenState();
}

class _TowingScreenState extends State<TowingScreen> {
  String? _selectedCarType;
  final _carTypes = ['سيدان', 'SUV', 'بيك أب', 'شاحنة', 'هاتشباك'];
  final _plateCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _destinationAddress = 'وجهة سحب السيارة';
  double? _destinationLat;
  double? _destinationLng;

  bool get _isValid =>
      _selectedCarType != null && _plateCtrl.text.trim().isNotEmpty;

  Future<void> _onDestinationTap() async {
    final cubit = context.read<LocationCubit>();
    final prev = cubit.state;
    await Navigator.pushNamed(context, Routes.locationPicker);
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

  void _onSubmit(BuildContext blocContext) {
    final loc = context.read<LocationCubit>().state;
    if (loc.lat == null || loc.lng == null) return;

    blocContext.read<RequestBloc>().add(CreateTowingRequestEvent(
          latitude: loc.lat!,
          longitude: loc.lng!,
          address: loc.address,
          destinationLatitude: _destinationLat,
          destinationLongitude: _destinationLng,
          destinationAddress: _destinationAddress != 'وجهة سحب السيارة' ? _destinationAddress : null,
          plateNumber: _plateCtrl.text.trim(),
          notes:
              _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
        ));
  }

  @override
  void initState() {
    super.initState();
    _plateCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequestBloc>(),
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestCreated) {
            Navigator.pushNamed(
              context,
              Routes.searchingDriver,
              arguments: SearchingArgs(
                searchingText: 'جاري البحث عن أقرب سائق ونش',
                subtitleText:
                    'نقوم الآن بمطابقة طلبك مع أقرب سيارة ونش متاحة في منطقتك.',
                nextRoute: Routes.driverFound,
                requestId: state.request.id,
                serviceType: 'towing',
              ),
            );
          } else if (state is RequestError) {
            final msg = state.message.contains('active')
                ? 'لديك طلب نشط بالفعل. يرجى إلغاؤه من الصفحة الرئيسية أولاً.'
                : state.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          }
        },
        child: Builder(
          builder: (blocContext) => Scaffold(
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
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: SafetyNoticeCard()),
                            const ServiceSectionHeader(
                                title: 'مسار الرحلة', gap: 16),
                            TowingRouteSection(
                                destinationAddress: _destinationAddress,
                                onDestinationTap: _onDestinationTap),
                            const ServiceSectionHeader(
                                title: 'تفاصيل السيارة', gap: 16),
                            TowingCarDetailsForm(
                                selectedCarType: _selectedCarType,
                                carTypes: _carTypes,
                                plateCtrl: _plateCtrl,
                                onCarTypeChanged: (v) =>
                                    setState(() => _selectedCarType = v)),
                            const ServiceSectionHeader(
                                title: 'ملاحظات إضافية', gap: 8),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ServiceInputField(
                                  hint: 'ملاحظات إضافية عن حالة السيارة',
                                  controller: _notesCtrl,
                                )),
                            const ServiceSectionHeader(
                                title: 'ملخص الدفع', gap: 16),
                            const PaymentSummary(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) => ServiceBottomButton(
                      isLoading: state is RequestLoading,
                      onPressed:
                          _isValid ? () => _onSubmit(blocContext) : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
