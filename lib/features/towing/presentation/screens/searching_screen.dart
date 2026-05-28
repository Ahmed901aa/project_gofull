import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/noti_service.dart';
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/searching_animation.dart';
import '../widgets/searching_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class SearchingScreen extends StatefulWidget {
  final SearchingArgs args;
  const SearchingScreen({super.key, required this.args});
  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  final _polling = OrderPollingService();
  late final RequestBloc _requestBloc;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _requestBloc = sl<RequestBloc>();

    developer.log(
      'SearchingScreen initState — requestId=${widget.args.requestId}, serviceType=${widget.args.serviceType}',
      name: 'SearchingScreen',
    );

    // Start polling for status changes every 3 seconds
    if (widget.args.requestId != null) {
      _polling.start(
        interval: const Duration(seconds: 3),
        callback: () async {
          if (!_navigated) {
            developer.log(
              'Polling → LoadRequestDetailsEvent(${widget.args.requestId})',
              name: 'SearchingScreen',
            );
            _requestBloc.add(LoadRequestDetailsEvent(widget.args.requestId!));
          }
        },
      );
    } else {
      developer.log(
        '⚠️ No requestId — polling NOT started!',
        name: 'SearchingScreen',
      );
    }
  }

  @override
  void dispose() {
    _polling.dispose();
    super.dispose();
  }

  void _onStatusChanged(BuildContext context, RequestState state) {
    if (_navigated || !mounted) return;

    developer.log(
      'State changed → ${state.runtimeType}',
      name: 'SearchingScreen',
    );

    if (state is RequestError) {
      developer.log(
        '⚠️ Polling error: ${state.message}',
        name: 'SearchingScreen',
      );
      return; // don't stop polling, try again next tick
    }

    if (state is! RequestDetailsLoaded) return;

    final request = state.request;
    final status = request.status.trim().toLowerCase();

    developer.log(
      'Request #${request.id} status="$status"',
      name: 'SearchingScreen',
    );

    // Stay on searching while pending
    if (status == 'pending') return;

    // Handle cancellation (from elsewhere)
    if (status == 'cancelled') {
      _navigated = true;
      _polling.stop();
      if (mounted) Navigator.pop(context);
      return;
    }

    // Status advanced — notify + navigate to DriverFoundScreen
    _navigated = true;
    _polling.stop();

    final isFuel = widget.args.serviceType == 'fuel_delivery';
    final providerUser =
        (request.providerInfo?['user'] as Map<String, dynamic>?) ?? {};
    final providerName =
        (providerUser['name'] as String?) ?? S.of(context).serviceProviderDefault;

    // Fire a local notification so the user sees it even if app is backgrounded
    NotiService().showNotification(
      id: request.id,
      title: isFuel ? S.of(context).fuelRequestAccepted : S.of(context).towRequestAccepted,
      body: S.of(context).providerOnWayToYouName(providerName),
    );
    final providerRating =
        request.providerInfo?['average_rating']?.toString();

    developer.log(
      'Navigating → driverFound with providerName="$providerName"',
      name: 'SearchingScreen',
    );

    try {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverFound,
        arguments: DriverFoundArgs(
          title: isFuel ? S.of(context).fuelProviderFoundTitle : S.of(context).towTruckFoundTitle,
          vehicleLabel: isFuel ? S.of(context).vehicleTypeLabel : S.of(context).towTruckTypeLabel,
          vehicleValue: isFuel ? S.of(context).fuelSupplyVehicle : S.of(context).hydraulicTowTruck,
          showClose: true,
          imagePath: isFuel
              ? 'assets/images/tank_truck.gif'
              : 'assets/images/magnifying_glass.gif',
          nextRoute: isFuel ? Routes.serviceArrived : Routes.towingStarted,
          requestId: request.id,
          providerName: providerName,
          providerRating: providerRating,
          serviceType: widget.args.serviceType,
        ),
      );
    } catch (e, stack) {
      developer.log(
        '❌ Navigation error: $e\n$stack',
        name: 'SearchingScreen',
      );
    }
  }

  void _onCancel() {
    _polling.stop();
    if (widget.args.requestId != null) {
      _requestBloc.add(CancelRequestEvent(widget.args.requestId!));
    }
    // Small delay so the cancel API call fires before navigating away
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: _onStatusChanged,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _onCancel();
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                const SearchingHeader(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SearchingAnimation(),
                          SizedBox(height: Insets.s16),
                          Text(widget.args.searchingText,
                              style: getBoldStyle(
                                  color: const Color(0xFF0E0E0E),
                                  fontSize: FontSize.s18),
                              textAlign: TextAlign.center),
                          SizedBox(height: Insets.s8),
                          Text(widget.args.subtitleText,
                              style: getRegularStyle(
                                  color: AppColors.neutral800,
                                  fontSize: FontSize.s14),
                              textAlign: TextAlign.center),
                          SizedBox(height: Insets.s16),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Insets.s16, vertical: Insets.s12),
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s16),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(
                              S.of(context).waitSafeLocation,
                              style: getRegularStyle(
                                  color: AppColors.primary,
                                  fontSize: FontSize.s14),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Cancel button
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Insets.s16, vertical: Insets.s12),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _onCancel,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.s12),
                          ),
                        ),
                        child: Text(S.of(context).cancelOrder,
                            style: getSemiBoldStyle(
                                color: AppColors.error,
                                fontSize: FontSize.s16)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
