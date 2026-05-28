import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/noti_service.dart';
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/core/widgets/provider_info_card.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/driver_found_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class DriverFoundScreen extends StatefulWidget {
  final DriverFoundArgs? args;
  const DriverFoundScreen({super.key, this.args});

  @override
  State<DriverFoundScreen> createState() => _DriverFoundScreenState();
}

class _DriverFoundScreenState extends State<DriverFoundScreen> {
  final _polling = OrderPollingService();
  late final RequestBloc _requestBloc;
  bool _navigated = false;
  bool _isEnRoute = false;
  // Track if this is the very first poll — used to suppress resume
  // notifications when the user re-enters this screen from home.
  bool _firstPoll = true;
  ServiceRequestEntity? _request;

  DriverFoundArgs get _args =>
      widget.args ??
      const DriverFoundArgs(
        title: '—',
        vehicleLabel: '—',
        vehicleValue: '—',
      );

  @override
  void initState() {
    super.initState();
    _requestBloc = sl<RequestBloc>();

    if (_args.requestId != null) {
      _polling.start(
        interval: const Duration(seconds: 3),
        callback: () async {
          if (!_navigated) {
            _requestBloc.add(LoadRequestDetailsEvent(_args.requestId!));
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _polling.dispose();
    super.dispose();
  }

  void _onStatusChanged(BuildContext context, RequestState state) {
    if (_navigated) return;

    if (state is! RequestDetailsLoaded) return;

    final request = state.request;
    final status = request.status.trim().toLowerCase();
    final isFuel = _args.serviceType == 'fuel_delivery';

    // On the very first poll we're just catching up to the current status,
    // not watching a transition — so skip notifications and only sync UI.
    final isResuming = _firstPoll;
    _firstPoll = false;

    setState(() => _request = request);

    // If we're resuming on en_route, remember that so we don't fire later.
    if (isResuming && status == 'en_route') {
      _isEnRoute = true;
    }

    developer.log(
      'DriverFoundScreen → status="$status"',
      name: 'DriverFoundScreen',
    );

    // Handle cancellation from provider side — pop back to home
    if (status == 'cancelled') {
      _navigated = true;
      _polling.stop();
      if (mounted) {
        AppSnackbar.warning(context, S.of(context).orderCancelledByProviderSearchAgain);
        Navigator.popUntil(context, (r) => r.isFirst);
      }
      return;
    }

    // en_route: stay on this screen, just update UI + notify
    if (status == 'en_route') {
      if (!_isEnRoute) {
        setState(() => _isEnRoute = true);
        NotiService().showNotification(
          id: request.id,
          title: S.of(context).providerOnTheWayTitle,
          body: isFuel ? S.of(context).fuelProviderMovedToYou : S.of(context).towDriverMovedToYou,
        );
      }
      return;
    }

    // Status advanced past en_route → notify + navigate forward
    if (status == 'arrived' ||
        status == 'in_progress' ||
        status == 'completed') {
      _navigated = true;
      _polling.stop();

      // Only notify on a real transition (not a resume catch-up).
      if (!isResuming) {
        final statusMessages = {
          'arrived': S.of(context).providerArrivedAtLocation,
          'in_progress': S.of(context).serviceStarted,
          'completed': S.of(context).serviceCompletedSuccessfully,
        };
        NotiService().showNotification(
          id: request.id,
          title: 'GoFull',
          body: statusMessages[status] ?? S.of(context).orderStatusUpdate,
        );
      }

      if (isFuel) {
        if (status == 'completed') {
          Navigator.pushReplacementNamed(context, Routes.fuelComplete,
              arguments: _args.requestId);
        } else {
          Navigator.pushReplacementNamed(
            context,
            Routes.serviceArrived,
            arguments: ServiceArrivedArgs(requestId: _args.requestId),
          );
        }
      } else {
        Navigator.pushReplacementNamed(
          context,
          Routes.towingStarted,
          arguments: TowingStartedArgs(requestId: _args.requestId),
        );
      }
    }
  }

  void _callProvider() {
    final userInfo =
        (_request?.providerInfo?['user'] as Map<String, dynamic>?) ?? {};
    final phone = userInfo['phone'] as String?;
    if (phone != null && phone.isNotEmpty) {
      launchUrl(Uri.parse('tel:$phone'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: _onStatusChanged,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: Column(
            children: [
              DriverFoundHeader(showClose: _args.showClose),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Insets.s16),
                      Center(
                        child: DottedCircleContainer(
                          imagePath: _isEnRoute
                              ? (_args.serviceType == 'fuel_delivery'
                                  ? 'assets/images/tank_truck.gif'
                                  : 'assets/images/magnifying_glass.gif')
                              : (_args.imagePath ??
                                  'assets/images/tank_truck.gif'),
                        ),
                      ),
                      SizedBox(height: Insets.s16),
                      Text(
                        _isEnRoute
                            ? (_args.serviceType == 'fuel_delivery'
                                ? S.of(context).fuelProviderOnWayToYou
                                : S.of(context).towDriverOnWayToYou)
                            : _args.title,
                        style: getBoldStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _isEnRoute
                            ? S.of(context).driverMovedWaitSafe
                            : S.of(context).driverAcceptedSubtitle,
                        style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Insets.s24),
                      ProviderInfoCard.fromRequest(
                        _request,
                        onCall: _callProvider,
                      ),
                      SizedBox(height: Insets.s16),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: SizedBox(height: Insets.s12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
