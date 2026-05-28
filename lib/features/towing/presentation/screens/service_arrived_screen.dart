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
import 'package:project_gofull/features/towing/presentation/widgets/safety_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ServiceArrivedScreen extends StatefulWidget {
  final ServiceArrivedArgs? args;
  const ServiceArrivedScreen({super.key, this.args});

  @override
  State<ServiceArrivedScreen> createState() => _ServiceArrivedScreenState();
}

class _ServiceArrivedScreenState extends State<ServiceArrivedScreen> {
  final _polling = OrderPollingService();
  late final RequestBloc _requestBloc;
  bool _navigated = false;
  ServiceRequestEntity? _request;

  ServiceArrivedArgs get _args => widget.args ?? const ServiceArrivedArgs();

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

    setState(() => _request = req);

    if (req.status == 'completed') {
      _navigated = true;
      _polling.stop();
      NotiService().showNotification(
        id: req.id,
        title: S.of(context).serviceCompletedSuccessfully,
        body: req.isFuelDelivery
            ? S.of(context).fuelCompletedBody
            : S.of(context).towCompletedBody,
      );
      Navigator.pushReplacementNamed(context, Routes.fuelComplete,
          arguments: _args.requestId);
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
                    Center(child: DottedCircleContainer(imagePath: _args.imagePath)),
                    SizedBox(height: Insets.s16),
                    Text(_args.title ?? S.of(context).serviceArrived,
                        style: getBoldStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s18),
                        textAlign: TextAlign.center),
                    SizedBox(height: 4.h),
                    Text(_args.subtitle ?? S.of(context).arrivedMsg,
                        style: getRegularStyle(
                            color: context.colors.textSecondary,
                            fontSize: FontSize.s14),
                        textAlign: TextAlign.center),
                    SizedBox(height: Insets.s16),
                    const SafetySection(),
                    SizedBox(height: Insets.s16),
                    ProviderInfoCard.fromRequest(
                      _request,
                      onCall: _callProvider,
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
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close_rounded,
                          size: 24.sp, color: context.colors.textPrimary)),
                  Text(S.of(context).refuelingInProgressHeader,
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
}
