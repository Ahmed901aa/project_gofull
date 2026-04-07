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
import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
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
  FuelPriceEntity? _selectedFuel;
  String? _selectedQuantity;
  final _quantities = ['20 لتر', '30 لتر', '40 لتر', '50 لتر', 'تعبئة كاملة'];
  final _notesController = TextEditingController();

  // Fallback fuel types when backend has no data or has old 91/95 types
  static const _fallbackFuelPrices = [
    FuelPriceEntity(id: 1, fuelType: 'gasoline', nameAr: 'بنزين', pricePerLiter: 0.75),
    FuelPriceEntity(id: 2, fuelType: 'diesel', nameAr: 'ديزل', pricePerLiter: 0.85),
  ];

  bool get _isValid => _selectedFuel != null && _selectedQuantity != null && (_isFullTank || _quantityNum > 0);

  @override
  void initState() {
    super.initState();
    // Reload fuel prices if they weren't loaded at startup
    final config = context.read<AppConfigBloc>().state;
    if (config.fuelPrices.isEmpty) {
      context.read<AppConfigBloc>().add(const LoadAppConfigEvent());
    }
  }

  bool get _isFullTank => _selectedQuantity == 'تعبئة كاملة';

  double get _quantityNum {
    if (_isFullTank) return 0; // full tank — price calculated by driver
    return double.tryParse((_selectedQuantity ?? '').replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
  }

  double get _subtotal {
    if (_isFullTank) return 0; // will be determined after filling
    return (_selectedFuel?.pricePerLiter ?? 0) * _quantityNum;
  }

  void _onSubmit(BuildContext blocContext) {
    final loc = context.read<LocationCubit>().state;
    if (loc.lat == null || loc.lng == null) return;

    final notes = _notesController.text.isNotEmpty ? _notesController.text : null;
    final fullTankNote = _isFullTank ? 'تعبئة كاملة' : null;
    final combinedNotes = [if (fullTankNote != null) fullTankNote, if (notes != null) notes].join(' - ');

    blocContext.read<RequestBloc>().add(CreateFuelRequestEvent(
          latitude: loc.lat!,
          longitude: loc.lng!,
          address: loc.address,
          fuelType: _selectedFuel!.fuelType,
          fuelQuantity: _isFullTank ? 0 : _quantityNum,
          notes: combinedNotes.isNotEmpty ? combinedNotes : null,
        ));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigBloc>().state;
    // Normalize: only show بنزين and ديزل (no 91/95 variants)
    final fuelPrices = _normalizeFuelPrices(config.fuelPrices);
    final fuelNames = fuelPrices.map((e) => e.nameAr).toList();

    return BlocProvider(
      create: (_) => sl<RequestBloc>(),
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestCreated) {
            Navigator.pushNamed(context, Routes.searchingDriver,
              arguments: SearchingArgs(
                searchingText: 'جاري البحث عن أقرب مزود وقود',
                subtitleText: 'نقوم الآن بمطابقة طلبك مع أقرب سيارة إمداد مجهزة بنوع الوقود المختار.',
                nextRoute: Routes.driverFound,
                requestId: state.request.id,
                serviceType: 'fuel_delivery',
              ));
          } else if (state is RequestError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SafetyNoticeCard()),
                            _section('الموقع', gap: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: BlocBuilder<LocationCubit, LocationState>(
                                builder: (context, loc) => ServiceLocationCard(
                                  topLabel: 'الموقع الحالي',
                                  bottomLabel: loc.address,
                                  onTap: () => Navigator.pushNamed(context, Routes.locationPicker),
                                ),
                              ),
                            ),
                            _section('تفاصيل الوقود', gap: 16),
                            if (config.isLoading && fuelNames.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            else if (fuelNames.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: GestureDetector(
                                  onTap: () => context.read<AppConfigBloc>().add(const LoadAppConfigEvent()),
                                  child: Text(
                                    'لم يتم تحميل أنواع الوقود. اضغط لإعادة المحاولة.',
                                    style: getRegularStyle(color: AppColors.error, fontSize: FontSize.s14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            else
                            FuelDetailsForm(
                              selectedFuelType: _selectedFuel?.nameAr,
                              selectedQuantity: _selectedQuantity,
                              fuelTypes: fuelNames,
                              quantities: _quantities,
                              onFuelTypeChanged: (v) {
                                setState(() {
                                  _selectedFuel = fuelPrices.firstWhere((e) => e.nameAr == v);
                                });
                              },
                              onQuantityChanged: (v) => setState(() => _selectedQuantity = v),
                            ),
                            // Show price per liter from backend
                            if (_selectedFuel != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  'سعر اللتر: ${_selectedFuel!.pricePerLiter.toStringAsFixed(2)} ${config.currency}',
                                  style: getMediumStyle(color: AppColors.primary, fontSize: FontSize.s14),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            _section('ملاحظات إضافية', gap: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: ServiceInputField(hint: 'ملاحظات إضافية عن حالة السيارة', controller: _notesController),
                            ),
                            _section('ملخص الدفع', gap: 16),
                            PaymentSummary(
                              subtotal: _isValid && !_isFullTank ? _subtotal : null,
                              serviceFee: config.serviceFee,
                              note: _isValid && _isFullTank ? 'سيتم تحديد السعر بعد التعبئة' : null,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) => ServiceBottomButton(
                      isLoading: state is RequestLoading,
                      onPressed: _isValid ? () => _onSubmit(blocContext) : null,
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
                style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                textAlign: TextAlign.right),
          ),
          SizedBox(height: gap),
        ],
      );
}
