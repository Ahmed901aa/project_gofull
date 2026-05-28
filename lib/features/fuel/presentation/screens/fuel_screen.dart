import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/cubits/location_state.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
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
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import '../widgets/fuel_details_form.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});
  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  FuelPriceEntity? _selectedFuel;
  String? _selectedQuantity;
  int? _selectedQuantityIndex;
  final _notesController = TextEditingController();

  List<String> _getQuantities(BuildContext context) {
    final l10n = S.of(context);
    return [l10n.liters20Qty, l10n.liters30Qty, l10n.liters40Qty, l10n.liters50Qty, l10n.fullTankQty];
  }

  /// Returns locale-aware display name for a fuel type.
  String _fuelDisplayName(FuelPriceEntity fuel, S l10n) {
    final type = fuel.fuelType.toLowerCase();
    if (type.contains('gasoline') || fuel.nameAr.contains('بنزين')) {
      return l10n.gasolineLabel;
    }
    if (type.contains('diesel') || fuel.nameAr.contains('ديزل')) {
      return l10n.dieselLabel;
    }
    return fuel.nameAr; // fallback for unknown types
  }

  // Fallback fuel types when backend has no data or has old 91/95 types
  static const _fallbackFuelPrices = [
    FuelPriceEntity(id: 1, fuelType: 'gasoline', nameAr: 'بنزين', pricePerLiter: 0.75),
    FuelPriceEntity(id: 2, fuelType: 'diesel', nameAr: 'ديزل', pricePerLiter: 0.85),
  ];

  bool _hasLocation(BuildContext context) {
    final loc = context.read<LocationCubit>().state;
    return loc.lat != null && loc.lng != null;
  }

  bool get _isFormValid =>
      _selectedFuel != null &&
      _selectedQuantity != null &&
      (_isFullTank || _quantityNum > 0);

  bool _isValid(BuildContext context) => _isFormValid && _hasLocation(context);

  String? _getValidationError(BuildContext context) {
    final l10n = S.of(context);
    if (_selectedFuel == null) {

      return l10n.pleaseSelectFuelType;

    }
    if (_selectedQuantity == null) {

      return l10n.pleaseSelectQuantity;

    }
    if (!_isFullTank && _quantityNum <= 0) {

      return l10n.pleaseSelectValidQuantity;

    }
    if (!_hasLocation(context)) return l10n.pleaseSelectLocation;
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Reload fuel prices if they weren't loaded at startup
    final config = context.read<AppConfigBloc>().state;
    if (config.fuelPrices.isEmpty) {
      context.read<AppConfigBloc>().add(const LoadAppConfigEvent());
    }
  }

  bool get _isFullTank => _selectedQuantityIndex == 4;

  double get _quantityNum {
    if (_isFullTank) {

      return 0;

    } // full tank — price calculated by driver
    return double.tryParse((_selectedQuantity ?? '').replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
  }

  double get _subtotal {
    if (_isFullTank) {

      return 0;

    } // will be determined after filling
    return (_selectedFuel?.pricePerLiter ?? 0) * _quantityNum;
  }

  void _onSubmit(BuildContext blocContext) {
    final loc = context.read<LocationCubit>().state;
    if (loc.lat == null || loc.lng == null) {

      return;

    }

    final l10n = S.of(context);
    final notes = _notesController.text.isNotEmpty ? _notesController.text : null;
    final fullTankNote = _isFullTank ? l10n.fullTankQty : null;
    final combinedNotes = [if (fullTankNote != null) fullTankNote, if (notes != null) notes].join(' - ');

    // Map fuel type to backend values: gasoline → petrol, diesel → diesel
    final apiFuelType = _selectedFuel!.fuelType == 'gasoline' ? 'petrol' : 'diesel';

    blocContext.read<RequestBloc>().add(CreateFuelRequestEvent(
          latitude: loc.lat!,
          longitude: loc.lng!,
          address: loc.address,
          fuelType: apiFuelType,
          fuelQuantity: _isFullTank ? 60 : _quantityNum,
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
    final l10n = S.of(context);
    final config = context.watch<AppConfigBloc>().state;
    // Normalize: only show gasoline and diesel (no 91/95 variants)
    final fuelPrices = _normalizeFuelPrices(config.fuelPrices);
    final fuelNames = fuelPrices.map((e) => _fuelDisplayName(e, l10n)).toList();
    final quantities = _getQuantities(context);

    return BlocProvider(
      create: (_) => sl<RequestBloc>(),
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          final l10n = S.of(context);
          if (state is RequestCreated) {
            BottomNavShell.markOrderActive(state.request.id);
            Navigator.pushNamed(context, Routes.searchingDriver,
              arguments: SearchingArgs(
                searchingText: l10n.searchingForFuelProvider,
                subtitleText: l10n.searchingFuelSubtitle,
                nextRoute: Routes.driverFound,
                requestId: state.request.id,
                serviceType: 'fuel_delivery',
              ));
          } else if (state is RequestError) {
            if (state.message.contains('active')) {
              AppSnackbar.warning(context, l10n.activeOrderWarning);
            } else {
              AppSnackbar.error(context, _friendlyError(context, state.message));
            }
          }
        },
        child: Builder(
          builder: (blocContext) => Scaffold(
            backgroundColor: context.colors.surface,
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  ServiceHeader(title: l10n.fuelScreenTitle),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SafetyNoticeCard()),
                            _section(l10n.locationSection, gap: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: BlocBuilder<LocationCubit, LocationState>(
                                builder: (context, loc) => ServiceLocationCard(
                                  topLabel: l10n.selectedLocation,
                                  bottomLabel: loc.address,
                                  onTap: () => Navigator.pushNamed(context, Routes.locationPicker),
                                ),
                              ),
                            ),
                            _section(l10n.fuelDetailsSection, gap: 16),
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
                                    l10n.fuelTypesNotLoaded,
                                    style: getRegularStyle(color: context.colors.error, fontSize: FontSize.s14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            else
                            FuelDetailsForm(
                              selectedFuelType: _selectedFuel != null ? _fuelDisplayName(_selectedFuel!, l10n) : null,
                              selectedQuantity: _selectedQuantity,
                              fuelTypes: fuelNames,
                              quantities: quantities,
                              onFuelTypeChanged: (v) {
                                setState(() {
                                  _selectedFuel = fuelPrices.firstWhere(
                                    (e) => _fuelDisplayName(e, l10n) == v,
                                    orElse: () => fuelPrices.first,
                                  );
                                });
                              },
                              onQuantityChanged: (v) {
                                setState(() {
                                  _selectedQuantity = v;
                                  _selectedQuantityIndex =
                                      v == null ? null : quantities.indexOf(v);
                                });
                              },
                            ),
                            // Show price per liter from backend
                            if (_selectedFuel != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  l10n.pricePerLiterDisplay(_selectedFuel!.pricePerLiter.toStringAsFixed(2), config.currency),
                                  style: getMediumStyle(color: context.colors.primary, fontSize: FontSize.s14),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            _section(l10n.additionalNotesSection, gap: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: ServiceInputField(hint: l10n.additionalNotesHintField, controller: _notesController),
                            ),
                            _section(l10n.paymentSummarySection, gap: 16),
                            PaymentSummary(
                              subtotal: _isFormValid && !_isFullTank ? _subtotal : null,
                              serviceFee: config.serviceFee,
                              note: _isFormValid && _isFullTank ? l10n.priceAfterFill : null,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) => BlocBuilder<LocationCubit, LocationState>(
                      builder: (context, loc) {
                        final isValid = _isValid(context);
                        return ServiceBottomButton(
                          isLoading: state is RequestLoading,
                          isEnabled: isValid,
                          onPressed: isValid
                              ? () => _onSubmit(blocContext)
                              : () {
                                  final err = _getValidationError(context);
                                  if (err != null) {
                                    AppSnackbar.warning(context, err);
                                  }
                                },
                        );
                      },
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

  /// Normalize fuel prices: collapse 91/95 variants into just بنزين + ديزل.
  List<FuelPriceEntity> _normalizeFuelPrices(List<FuelPriceEntity> raw) {
    if (raw.isEmpty) {

      return List.of(_fallbackFuelPrices);

    }

    // Try to find gasoline price from backend (any 91/95/gasoline match)
    FuelPriceEntity? gasoline;
    FuelPriceEntity? diesel;

    for (final e in raw) {
      final type = e.fuelType.toLowerCase();
      final name = e.nameAr;
      if (gasoline == null &&
          (type.contains('gasoline') || type.contains('91') ||
           type.contains('95') || name.contains('بنزين'))) {
        gasoline = e;
      }
      if (diesel == null &&
          (type.contains('diesel') || name.contains('ديزل'))) {
        diesel = e;
      }
    }

    return [
      FuelPriceEntity(
        id: gasoline?.id ?? 1,
        fuelType: 'gasoline',
        nameAr: 'بنزين',
        pricePerLiter: gasoline?.pricePerLiter ?? 0.75,
      ),
      FuelPriceEntity(
        id: diesel?.id ?? 2,
        fuelType: 'diesel',
        nameAr: 'ديزل',
        pricePerLiter: diesel?.pricePerLiter ?? 0.85,
      ),
    ];
  }

  String _friendlyError(BuildContext context, String raw) {
    final l10n = S.of(context);
    if (raw.contains('network') || raw.contains('connection') || raw.contains('SocketException')) {
      return l10n.networkError;
    }
    if (raw.contains('server') || raw.contains('500')) {
      return l10n.serverError;
    }
    if (raw.contains('unauthorized') || raw.contains('401')) {
      return l10n.sessionExpired;
    }
    if (raw.contains('permission') || raw.contains('403')) {
      return l10n.permissionDenied;
    }
    return raw;
  }

  Widget _section(String title, {required double gap}) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title,
                style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18),
                textAlign: TextAlign.start),
          ),
          SizedBox(height: gap),
        ],
      );
}
