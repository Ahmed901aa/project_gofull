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
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/safety_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class TowingStartedScreen extends StatefulWidget {
  final TowingStartedArgs? args;
  const TowingStartedScreen({super.key, this.args});

  @override
  State<TowingStartedScreen> createState() => _TowingStartedScreenState();
}

class _TowingStartedScreenState extends State<TowingStartedScreen> {
  final _polling = OrderPollingService();
  late final RequestBloc _requestBloc;
  bool _navigated = false;
  ServiceRequestEntity? _request;

  String _destinationAddress = '';

  TowingStartedArgs get _args => widget.args ?? const TowingStartedArgs();

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

  void _onState(RequestState state) {
    if (_navigated || state is! RequestDetailsLoaded) return;
    final req = state.request;
    setState(() {
      _request = req;
      _destinationAddress = req.destinationAddress ?? '';
    });

    if (req.status == 'in_progress' || req.status == 'completed') {
      _navigated = true;
      _polling.stop();
      Navigator.pushReplacementNamed(
        context,
        Routes.tripInProgress,
        arguments: TripInProgressArgs(
          originAddress: req.driverAddress ?? '',
          destinationAddress: req.destinationAddress ?? '',
          originLat: double.tryParse(req.driverLatitude),
          originLng: double.tryParse(req.driverLongitude),
          destinationLat: double.tryParse(req.destinationLatitude ?? ''),
          destinationLng: double.tryParse(req.destinationLongitude ?? ''),
          requestId: _args.requestId,
        ),
      );
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
    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) => _onState(state),
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: Column(children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(children: [
                  SizedBox(height: Insets.s16),
                  DottedCircleContainer(imagePath: _args.imagePath),
                  SizedBox(height: Insets.s16),
                  Text(_args.title ?? S.of(context).towingStartHeader,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s18),
                      textAlign: TextAlign.center),
                  SizedBox(height: 4.h),
                  Text(_args.subtitle ?? S.of(context).carBeingTransported,
                      style: getRegularStyle(
                          color: AppColors.neutral800,
                          fontSize: FontSize.s14),
                      textAlign: TextAlign.center),
                  SizedBox(height: Insets.s16),
                  if (_destinationAddress.isNotEmpty) ...[
                    _buildDestinationCard(),
                    SizedBox(height: Insets.s16),
                  ],
                  SafetySection(items: [S.of(context).closeWindowsSafety, S.of(context).personalBelongingsSafety]),
                  SizedBox(height: Insets.s16),
                  _buildDriverSection(),
                  SizedBox(height: Insets.s16),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 24.sp),
                  Text(S.of(context).towingStartHeader,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20)),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: const Color(0xFF0E0E0E)),
                ]),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );

  Widget _buildDestinationCard() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Row(children: [
          Icon(Icons.location_on_rounded, size: 22.sp, color: AppColors.primary),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).deliveryDestination,
                    style: getRegularStyle(
                        color: AppColors.neutral800, fontSize: FontSize.s12)),
                SizedBox(height: 2.h),
                Text(_destinationAddress,
                    style: getMediumStyle(
                        color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ]),
      );

  Widget _buildDriverSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.of(context).providerDetails,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              textAlign: TextAlign.right),
          SizedBox(height: Insets.s8),
          ProviderInfoCard.fromRequest(
            _request,
            onCall: _callProvider,
          ),
        ],
      );
}
