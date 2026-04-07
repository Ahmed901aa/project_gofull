import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/eta_bottom_panel.dart';
import '../widgets/driver_found_body.dart';
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
  String _panelLabel = 'في انتظار تحرك مزود الخدمة';

  DriverFoundArgs get _args =>
      widget.args ??
      const DriverFoundArgs(
        title: 'تم العثور على ونش!',
        vehicleLabel: 'نوع الونش',
        vehicleValue: 'ونش هيدروليك',
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

      if (isFuel) {
        // en_route: stay on this screen (supplier on the way), keep polling
        if (request.status == 'en_route') {
          setState(() => _panelLabel = 'مزود الوقود في الطريق إليك');
          return;
        }

        // arrived/in_progress/completed: navigate to refueling or complete
        _navigated = true;
        _polling.stop();
        if (request.status == 'completed') {
          Navigator.pushReplacementNamed(context, Routes.fuelComplete);
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
            nextRouteArgs: TripInProgressArgs(
              originAddress: request.driverAddress ?? '',
              destinationAddress: '',
              requestId: _args.requestId,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) => _onStatusChanged(state),
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              DriverFoundHeader(showClose: _args.showClose),
              Expanded(
                child: DriverFoundBody(
                  imagePath:
                      _args.imagePath ?? 'assets/images/tank_truck.gif',
                  title: _args.title,
                  driverName: _args.providerName ?? 'مزود الخدمة',
                  driverRating: _args.providerRating ?? '-',
                  driverReviewCount: '',
                  driverPlateNumber: '',
                  vehicleLabel: _args.vehicleLabel,
                  vehicleValue: _args.vehicleValue,
                ),
              ),
              EtaBottomPanel(
                etaFormatted: '...',
                progress: 0,
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
