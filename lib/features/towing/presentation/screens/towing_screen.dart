import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/payment_summary.dart';
import 'package:project_gofull/core/widgets/safety_notice_card.dart';
import 'package:project_gofull/core/widgets/service_bottom_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import '../widgets/service_section_header.dart';
import '../widgets/towing_car_details_form.dart';
import '../widgets/towing_route_section.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class TowingScreen extends StatefulWidget {
  const TowingScreen({super.key});
  @override
  State<TowingScreen> createState() => _TowingScreenState();
}

class _TowingScreenState extends State<TowingScreen> {
  final _carTypeCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _destinationAddress;
  double? _destinationLat;
  double? _destinationLng;

  bool _hasLocation(BuildContext context) {
    final loc = context.read<LocationCubit>().state;
    return loc.lat != null && loc.lng != null;
  }

  bool get _hasDestination => _destinationLat != null && _destinationLng != null;

  bool get _isFormValid =>
      _plateCtrl.text.trim().isNotEmpty &&
      _carTypeCtrl.text.trim().isNotEmpty &&
      _hasDestination;

  bool _isValid(BuildContext context) => _isFormValid && _hasLocation(context);

  String? _getValidationError(BuildContext context) {
    final l10n = S.of(context);
    if (!_hasLocation(context)) return l10n.pleaseSelectLocation;
    if (!_hasDestination) return l10n.pleaseSelectDestination;
    if (_carTypeCtrl.text.trim().isEmpty) return l10n.pleaseEnterCarType;
    if (_plateCtrl.text.trim().isEmpty) return l10n.pleaseEnterPlateNumber;
    return null;
  }

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
    if (_destinationLat == null || _destinationLng == null) return;
    if (_carTypeCtrl.text.trim().isEmpty) return;

    blocContext.read<RequestBloc>().add(CreateTowingRequestEvent(
          latitude: loc.lat!,
          longitude: loc.lng!,
          address: loc.address,
          destinationLatitude: _destinationLat!,
          destinationLongitude: _destinationLng!,
          destinationAddress: _destinationAddress,
          plateNumber: _plateCtrl.text.trim(),
          carType: _carTypeCtrl.text.trim(),
          notes:
              _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
        ));
  }

  @override
  void initState() {
    super.initState();
    _carTypeCtrl.addListener(() => setState(() {}));
    _plateCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _carTypeCtrl.dispose();
    _plateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return BlocProvider(
      create: (_) => sl<RequestBloc>(),
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          final l10n = S.of(context);
          if (state is RequestCreated) {
            BottomNavShell.markOrderActive(state.request.id);
            Navigator.pushNamed(
              context,
              Routes.searchingDriver,
              arguments: SearchingArgs(
                searchingText: l10n.searchingForTowProvider,
                subtitleText: l10n.searchingTowSubtitle,
                nextRoute: Routes.driverFound,
                requestId: state.request.id,
                serviceType: 'towing',
              ),
            );
          } else if (state is RequestError) {
            if (state.message.contains('active')) {
              AppSnackbar.warning(context, l10n.activeOrderWarning);
            } else {
              AppSnackbar.error(context, state.message);
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
                  ServiceHeader(title: l10n.towingScreenTitle),
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
                            ServiceSectionHeader(
                                title: l10n.tripRouteSection, gap: 16),
                            TowingRouteSection(
                                destinationAddress: _destinationAddress ?? l10n.towingDestinationPlaceholder,
                                onDestinationTap: _onDestinationTap),
                            ServiceSectionHeader(
                                title: l10n.carDetailsSectionTitle, gap: 16),
                            TowingCarDetailsForm(
                                carTypeCtrl: _carTypeCtrl,
                                plateCtrl: _plateCtrl),
                            ServiceSectionHeader(
                                title: l10n.additionalNotesSection, gap: 8),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ServiceInputField(
                                  hint: l10n.additionalNotesHintField,
                                  controller: _notesCtrl,
                                )),
                            ServiceSectionHeader(
                                title: l10n.paymentSummarySection, gap: 16),
                            const PaymentSummary(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
