import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/services/noti_service.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/core/widgets/provider_info_card.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import '../widgets/trip_photo_placeholder.dart';
import '../widgets/trip_route_card.dart';
import '../widgets/trip_payment_section.dart';
import '../widgets/trip_safety_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

String _calcDistance(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = (lat2 - lat1) * pi / 180;
  final dLng = (lng2 - lng1) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final km = r * 2 * atan2(sqrt(a), sqrt(1 - a));
  return '${km.toStringAsFixed(1)}'; // unit added by caller
}

class TripInProgressScreen extends StatefulWidget {
  final TripInProgressArgs? args;
  const TripInProgressScreen({super.key, this.args});

  @override
  State<TripInProgressScreen> createState() => _TripInProgressScreenState();
}

class _TripInProgressScreenState extends State<TripInProgressScreen> {
  final _polling = OrderPollingService();
  late final RequestBloc _requestBloc;
  bool _navigated = false;
  ServiceRequestEntity? _request;

  String? _subtotal;
  String? _serviceFee;
  String? _total;

  @override
  void initState() {
    super.initState();
    _requestBloc = sl<RequestBloc>();
    final reqId = widget.args?.requestId;
    if (reqId != null) {
      _polling.start(
        interval: const Duration(seconds: 3),
        callback: () async {
          if (!_navigated) _requestBloc.add(LoadRequestDetailsEvent(reqId));
        },
      );
    }
  }

  @override
  void dispose() {
    _polling.dispose();
    super.dispose();
  }

  void _onState(RequestState state) {
    if (_navigated || state is! RequestDetailsLoaded) return;
    final req = state.request;
    setState(() {
      _request = req;
      _subtotal = req.subtotal;
      _serviceFee = req.serviceFee;
      _total = req.total;
    });

    if (req.status == 'completed') {
      _navigated = true;
      _polling.stop();
      Navigator.pushReplacementNamed(context, Routes.driverArrived,
          arguments: widget.args);
    }

    if (req.status == 'cancelled') {
      _navigated = true;
      _polling.stop();
      NotiService().showNotification(
        id: req.id,
        title: S.of(context).orderCancelledTitle,
        body: S.of(context).orderCancelledByProviderBody,
      );
      Navigator.pushReplacementNamed(context, Routes.home);
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
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) => _onState(state),
        child: Scaffold(
          backgroundColor: context.colors.background,
          body: Column(children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Insets.s16),
                    const Center(
                        child: DottedCircleContainer(
                            imagePath: 'assets/images/crane (1).gif')),
                    SizedBox(height: Insets.s16),
                    Text(S.of(context).carOnWayToDestination,
                        style: getBoldStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s18),
                        textAlign: TextAlign.center),
                    SizedBox(height: 4.h),
                    Text(
                        S.of(context).carBeingTransported,
                        style: getRegularStyle(
                            color: context.colors.textSecondary,
                            fontSize: FontSize.s14),
                        textAlign: TextAlign.center),
                    SizedBox(height: Insets.s24),
                    const TripSafetySection(),
                    SizedBox(height: Insets.s16),
                    _buildTripRoute(),
                    SizedBox(height: Insets.s16),
                    _buildCarPhotos(),
                    SizedBox(height: Insets.s16),
                    _buildDriverDetails(),
                    SizedBox(height: Insets.s16),
                    TripPaymentSection(
                      subtotal: _subtotal != null
                          ? '$_subtotal $cur'
                          : '— $cur',
                      serviceFee: _serviceFee != null
                          ? '$_serviceFee $cur'
                          : '${config.serviceFee.toStringAsFixed(2)} $cur',
                      total:
                          _total != null ? '$_total $cur' : '— $cur',
                    ),
                    SizedBox(height: Insets.s16),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 24.sp),
                  Text(S.of(context).tripInProgressHeader,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s20)),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: context.colors.textPrimary),
                ]),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ]),
      );

  Widget _buildTripRoute() {
    final origin = widget.args?.originAddress ?? '';
    final destination = widget.args?.destinationAddress ?? '';
    String distance = '—';
    if (widget.args?.originLat != null &&
        widget.args?.originLng != null &&
        widget.args?.destinationLat != null &&
        widget.args?.destinationLng != null) {
      distance = _calcDistance(widget.args!.originLat!, widget.args!.originLng!,
          widget.args!.destinationLat!, widget.args!.destinationLng!);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.of(context).routeSection,
            style: getBoldStyle(
                color: context.colors.textPrimary, fontSize: FontSize.s18),
            textAlign: TextAlign.start),
        SizedBox(height: Insets.s8),
        TripRouteCard(title: S.of(context).departurePoint, address: origin),
        SizedBox(height: Insets.s8),
        TripRouteCard(
            title: S.of(context).deliveryDestination,
            address: destination,
            distanceLabel: S.of(context).remainingDistance,
            distanceValue: '${distance} ${S.of(context).kmUnit}'),
      ],
    );
  }

  Widget _buildCarPhotos() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.of(context).carPhotos,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s18),
              textAlign: TextAlign.start),
          SizedBox(height: Insets.s8),
          Row(
              children: List.generate(
                  3,
                  (i) => Expanded(
                      child: Padding(
                          padding:
                              EdgeInsetsDirectional.only(end: i < 2 ? Insets.s8 : 0),
                          child: const TripPhotoPlaceholder())))),
        ],
      );

  Widget _buildDriverDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.of(context).providerDetails,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s18),
              textAlign: TextAlign.start),
          SizedBox(height: Insets.s8),
          ProviderInfoCard.fromRequest(
            _request,
            onCall: _callProvider,
          ),
        ],
      );
}
