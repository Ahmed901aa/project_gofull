import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import '../widgets/arrived_bottom_action.dart';
import '../widgets/arrived_car_photos.dart';
import '../widgets/arrived_payment_card.dart';
import '../widgets/arrived_safety_card.dart';
import '../widgets/gif_circle.dart';

class DriverArrivedScreen extends StatefulWidget {
  final TripInProgressArgs? args;
  const DriverArrivedScreen({super.key, this.args});

  @override
  State<DriverArrivedScreen> createState() => _DriverArrivedScreenState();
}

class _DriverArrivedScreenState extends State<DriverArrivedScreen> {
  late final RequestBloc _requestBloc;
  String _subtotal = '—';
  String _serviceFee = '—';
  String _total = '—';

  @override
  void initState() {
    super.initState();
    // Customer is IN the app when they see the arrival/completion screen
    BottomNavShell.markCompletedInApp();
    _requestBloc = sl<RequestBloc>();
    final reqId = widget.args?.requestId;
    if (reqId != null) {
      _requestBloc.add(LoadRequestDetailsEvent(reqId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestDetailsLoaded) {
            final req = state.request;
            setState(() {
              _subtotal = req.subtotal != null ? '${req.subtotal} $cur' : '— $cur';
              _serviceFee = req.serviceFee != null
                  ? '${req.serviceFee} $cur'
                  : '${config.serviceFee.toStringAsFixed(2)} $cur';
              _total = req.total != null ? '${req.total} $cur' : '— $cur';
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Insets.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Insets.s16),
                      Center(child: GifCircle(imagePath: 'assets/images/shield.gif')),
                      SizedBox(height: Insets.s16),
                      Text(
                        'تمت المهمة بنجاح!',
                        style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'تم إنزال السيارة في وجهة التوصيل المحددة. يرجى التأكد من سلامة السيارة قبل إتمام الدفع.',
                        style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Insets.s24),
                      const ArrivedSafetyCard(),
                      SizedBox(height: Insets.s16),
                      const ArrivedCarPhotos(),
                      SizedBox(height: Insets.s16),
                      ArrivedPaymentCard(
                        subtotal: _subtotal,
                        serviceFee: _serviceFee,
                        total: _total,
                      ),
                      SizedBox(height: Insets.s16),
                    ],
                  ),
                ),
              ),
              const ArrivedBottomAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24.sp),
                Text('وصول السيارة',
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );
}
