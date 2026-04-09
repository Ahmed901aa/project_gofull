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
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/core/widgets/provider_info_card.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
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
  ServiceRequestEntity? _request;
  bool _isCancelling = false;

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

    if (state is RequestCancelled) {
      // Our own cancel call succeeded
      _navigated = true;
      _polling.stop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إلغاء الطلب بنجاح')),
        );
        Navigator.popUntil(context, (r) => r.isFirst);
      }
      return;
    }

    if (state is RequestError && _isCancelling) {
      setState(() => _isCancelling = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
      return;
    }

    if (state is! RequestDetailsLoaded) return;

    final request = state.request;
    final status = request.status.trim().toLowerCase();
    final isFuel = _args.serviceType == 'fuel_delivery';

    setState(() => _request = request);

    developer.log(
      'DriverFoundScreen → status="$status"',
      name: 'DriverFoundScreen',
    );

    // Handle cancellation from provider side — pop back to home
    if (status == 'cancelled') {
      _navigated = true;
      _polling.stop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إلغاء الطلب')),
        );
        Navigator.popUntil(context, (r) => r.isFirst);
      }
      return;
    }

    // en_route: stay on this screen, just update UI
    if (status == 'en_route') {
      if (!_isEnRoute) setState(() => _isEnRoute = true);
      return;
    }

    // Status advanced past en_route → navigate forward
    if (status == 'arrived' ||
        status == 'in_progress' ||
        status == 'completed') {
      _navigated = true;
      _polling.stop();

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

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إلغاء الطلب'),
          content: const Text(
              'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟ سيتم إعلام مزود الخدمة.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('تراجع'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('نعم، إلغاء',
                  style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && _args.requestId != null && mounted) {
      setState(() => _isCancelling = true);
      _requestBloc.add(CancelRequestEvent(_args.requestId!));
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
                              ? 'assets/images/magnifying_glass.gif'
                              : (_args.imagePath ??
                                  'assets/images/tank_truck.gif'),
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
              // Cancel button — always visible while on this screen
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.s16, vertical: Insets.s12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: _isCancelling ? null : _confirmCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.s12),
                        ),
                      ),
                      child: _isCancelling
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.error,
                              ),
                            )
                          : Text(
                              'إلغاء الطلب',
                              style: getSemiBoldStyle(
                                  color: AppColors.error,
                                  fontSize: FontSize.s16),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
