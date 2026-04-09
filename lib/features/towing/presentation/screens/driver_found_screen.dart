import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
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
import 'package:project_gofull/features/towing/presentation/widgets/eta_bottom_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/driver_found_header.dart';

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
  String _panelLabel = 'في انتظار تحرك مزود الخدمة';
  ServiceRequestEntity? _request;

  DriverFoundArgs get _args =>
      widget.args ??
      const DriverFoundArgs(
        title: 'تم العثور على مزود الخدمة!',
        vehicleLabel: 'نوع المركبة',
        vehicleValue: '—',
      );

  @override
  void initState() {
    super.initState();
    _requestBloc = sl<RequestBloc>();

    // Poll for status changes every 3s
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

  void _onStatusChanged(RequestState state) {
    if (_navigated || state is! RequestDetailsLoaded) return;
    final request = state.request;
    final isFuel = _args.serviceType == 'fuel_delivery';

    // Update provider info in state
    setState(() => _request = request);

    // Handle cancellation — go back
    if (request.status == 'cancelled') {
      _navigated = true;
      _polling.stop();
      if (mounted) Navigator.pop(context);
      return;
    }

    // Navigate when status advances beyond 'accepted'
    if (request.status == 'en_route' ||
        request.status == 'arrived' ||
        request.status == 'in_progress' ||
        request.status == 'completed') {

      if (request.status == 'en_route') {
        setState(() {
          _isEnRoute = true;
          _panelLabel = isFuel
              ? 'مزود الوقود في الطريق إليك'
              : 'سائق الونش في الطريق إليك';
        });
        return;
      }

      _navigated = true;
      _polling.stop();

      if (isFuel) {
        if (request.status == 'completed') {
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
          arguments: TowingStartedArgs(
            requestId: _args.requestId,
          ),
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
        listener: (context, state) => _onStatusChanged(state),
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
                              ? 'assets/images/magnifying_glass.gif'
                              : (_args.imagePath ?? 'assets/images/tank_truck.gif'),
                        ),
                      ),
                      SizedBox(height: Insets.s16),
                      Text(
                        _isEnRoute
                            ? (_args.serviceType == 'fuel_delivery'
                                ? 'مزود الوقود في الطريق إليك'
                                : 'سائق الونش في الطريق إليك')
                            : _args.title,
                        style: getBoldStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _isEnRoute
                            ? 'السائق تحرك إلى موقعك، يرجى الانتظار في مكان آمن.'
                            : 'وافق السائق على طلبك وهو الآن في طريقه إليك.',
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
              EtaBottomPanel(
                etaFormatted: '...',
                progress: _isEnRoute ? 0.4 : 0,
                label: _panelLabel,
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
