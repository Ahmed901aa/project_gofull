import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/searching_animation.dart';
import '../widgets/searching_header.dart';

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

    // Start polling for status changes every 3 seconds
    if (widget.args.requestId != null) {
      _polling.start(
        interval: const Duration(seconds: 3),
        callback: () async {
          if (!_navigated) {
            _requestBloc.add(LoadRequestDetailsEvent(widget.args.requestId!));
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
    if (_navigated) return;

    if (state is RequestDetailsLoaded) {
      final request = state.request;

      // When a provider accepts → navigate to DriverFound
      if (request.status != 'pending') {
        _navigated = true;
        _polling.stop();

        final isFuel = widget.args.serviceType == 'fuel_delivery';
        final providerName =
            (request.providerInfo?['user'] as Map?)?['name'] as String? ??
                'مزود الخدمة';

        Navigator.pushReplacementNamed(
          context,
          Routes.driverFound,
          arguments: DriverFoundArgs(
            title: isFuel ? 'تم العثور على مزود وقود!' : 'تم العثور على ونش!',
            vehicleLabel: isFuel ? 'نوع المركبة' : 'نوع الونش',
            vehicleValue: isFuel ? 'سيارة إمداد وقود' : 'ونش هيدروليك',
            showClose: true,
            imagePath: isFuel
                ? 'assets/images/tank_truck.gif'
                : 'assets/images/magnifying_glass.gif',
            nextRoute:
                isFuel ? Routes.serviceArrived : Routes.towingStarted,
            requestId: request.id,
            providerName: providerName,
            serviceType: widget.args.serviceType,
          ),
        );
      }
    }
  }

  void _onCancel() {
    _polling.stop();
    if (widget.args.requestId != null) {
      _requestBloc.add(CancelRequestEvent(widget.args.requestId!));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) => _onStatusChanged(state),
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
                              'يرجى الانتظار في مكان آمن بعيداً عن حركة المرور وتشغيل أضواء التنبيه في سيارتك حتى وصول السائق.',
                              style: getRegularStyle(
                                  color: AppColors.primary,
                                  fontSize: FontSize.s14),
                              textAlign: TextAlign.right,
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
                        child: Text('إلغاء الطلب',
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
