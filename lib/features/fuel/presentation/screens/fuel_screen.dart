import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/cubits/location_state.dart';
import 'package:project_gofull/core/di/injection_container.dart';
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
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
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
  final _notesController = TextEditingController();

  bool get _isValid => _selectedFuelType != null && _selectedQuantity != null;

  /// Map Arabic fuel type to backend enum
  String _mapFuelType(String arabic) {
    if (arabic == 'ديزل') return 'diesel';
    return 'petrol'; // بنزين 91 or 95
  }

  /// Extract numeric quantity from "20 لتر"
  double _mapQuantity(String arabic) {
    return double.tryParse(arabic.replaceAll(RegExp(r'[^\d.]'), '')) ?? 20;
  }

  void _onSubmit(BuildContext blocContext) {
    final loc = context.read<LocationCubit>().state;
    if (loc.lat == null || loc.lng == null) return;

    blocContext.read<RequestBloc>().add(CreateFuelRequestEvent(
          latitude: loc.lat!,
          longitude: loc.lng!,
          address: loc.address,
          fuelType: _mapFuelType(_selectedFuelType!),
          fuelQuantity: _mapQuantity(_selectedQuantity!),
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : null,
        ));
  }

  @override
  void dispose() {
    _notesController.dispose();
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
                searchingText: 'جاري البحث عن أقرب مزود وقود',
                subtitleText:
                    'نقوم الآن بمطابقة طلبك مع أقرب سيارة إمداد مجهزة بنوع الوقود المختار.',
                nextRoute: Routes.driverFound,
                requestId: state.request.id,
                serviceType: 'fuel_delivery',
              ),
            );
          } else if (state is RequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
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
                  const ServiceHeader(title: 'إمداد وقود'),
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
                            _section('الموقع', gap: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: BlocBuilder<LocationCubit, LocationState>(
                                builder: (context, loc) => ServiceLocationCard(
                                  topLabel: 'الموقع الحالي',
                                  bottomLabel: loc.address,
                                  onTap: () => Navigator.pushNamed(
                                      context, Routes.locationPicker),
                                ),
                              ),
                            ),
                            _section('تفاصيل الوقود', gap: 16),
                            FuelDetailsForm(
                              selectedFuelType: _selectedFuelType,
                              selectedQuantity: _selectedQuantity,
                              fuelTypes: _fuelTypes,
                              quantities: _quantities,
                              onFuelTypeChanged: (v) =>
                                  setState(() => _selectedFuelType = v),
                              onQuantityChanged: (v) =>
                                  setState(() => _selectedQuantity = v),
                            ),
                            _section('ملاحظات إضافية', gap: 8),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ServiceInputField(
                                  hint: 'ملاحظات إضافية عن حالة السيارة',
                                  controller: _notesController,
                                )),
                            _section('ملخص الدفع', gap: 16),
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

  Widget _section(String title, {required double gap}) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title,
                style: getBoldStyle(
                    color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                textAlign: TextAlign.right),
          ),
          SizedBox(height: gap),
        ],
      );
}
