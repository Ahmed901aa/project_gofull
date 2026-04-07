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
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/driver_details_card.dart';
import 'package:project_gofull/features/towing/presentation/widgets/safety_section.dart';

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

  // Real data from API
  String _providerName = 'مزود الخدمة';
  String _providerRating = '-';
  String _providerPlate = '';

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

    // Update driver info from real data
    final provUser = (req.providerInfo?['user'] as Map<String, dynamic>?) ?? {};
    setState(() {
      _providerName = (provUser['name'] as String?) ?? 'مزود الخدمة';
      _providerRating = (req.providerInfo?['average_rating']?.toString()) ?? '-';
      _providerPlate = (req.providerInfo?['vehicle_plate'] as String?) ?? '';
    });

    // Navigate on status change
    if (req.status == 'completed') {
      _navigated = true;
      _polling.stop();
      Navigator.pushReplacementNamed(context, Routes.fuelComplete,
          arguments: _args.requestId);
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
                  Text(_args.title,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s18),
                      textAlign: TextAlign.center),
                  SizedBox(height: 4.h),
                  Text(_args.subtitle,
                      style: getRegularStyle(
                          color: AppColors.neutral800,
                          fontSize: FontSize.s14),
                      textAlign: TextAlign.center),
                  SizedBox(height: Insets.s16),
                  const SafetySection(),
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
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close_rounded,
                          size: 24.sp, color: const Color(0xFF0E0E0E))),
                  Text('جاري التعبئة',
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

  Widget _buildDriverSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('تفاصيل السائق',
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              textAlign: TextAlign.right),
          SizedBox(height: Insets.s8),
          DriverDetailsCard(
            name: _providerName,
            rating: _providerRating,
            reviewCount: '',
            plateNumber: _providerPlate,
            vehicleLabel: _args.vehicleLabel,
            vehicleValue: _args.vehicleValue,
            showActionIcons: true,
          ),
        ],
      );
}
