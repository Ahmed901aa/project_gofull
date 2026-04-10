import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/provider_info_card.dart';
import 'package:project_gofull/core/widgets/rating_bottom_sheet.dart';
import 'package:project_gofull/core/widgets/service_location_card.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/detail_chip.dart';
import 'package:project_gofull/features/towing/presentation/widgets/trip_payment_section.dart';
import 'package:project_gofull/features/towing/presentation/widgets/trip_rating_bottom_bar.dart';

class TowingTripDetailsScreen extends StatelessWidget {
  final TripDetailsArgs? args;
  const TowingTripDetailsScreen({super.key, this.args});

  bool get _showRatingButton =>
      args != null && args!.status == OrderStatus.completed && !args!.isRated;

  bool get _showAlreadyRatedText =>
      args != null && args!.status == OrderStatus.completed && args!.isRated;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<RequestBloc>();
        final id = int.tryParse(args?.orderId ?? '');
        if (id != null) bloc.add(LoadRequestDetailsEvent(id));
        return bloc;
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<RequestBloc, RequestState>(
                builder: (context, state) {
                  ServiceRequestEntity? loadedRequest;
                  Widget body;
                  if (state is RequestLoading) {
                    body = const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary));
                  } else if (state is RequestDetailsLoaded) {
                    loadedRequest = state.request;
                    body = _buildContent(context, state.request);
                  } else if (state is RequestError) {
                    body = Center(
                        child: Text(state.message,
                            style: getRegularStyle(
                                color: AppColors.grey,
                                fontSize: FontSize.s14)));
                  } else {
                    body = const SizedBox.shrink();
                  }

                  return Column(children: [
                    Expanded(child: body),
                    if (_showRatingButton && loadedRequest != null)
                      TripRatingBottomBar(
                          label: 'تقييم الرحلة',
                          onPressed: () =>
                              showRatingBottomSheet(context, loadedRequest!)),
                    if (_showAlreadyRatedText) const AlreadyRatedBar(),
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ServiceRequestEntity req) {
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Sizes.s8),
          _section(
              'مسار الرحلة',
              Column(children: [
                ServiceLocationCard(
                    topLabel: 'نقطة الانطلاق',
                    bottomLabel: req.driverAddress ?? '—'),
                SizedBox(height: Sizes.s8),
                ServiceLocationCard(
                    topLabel: 'وجهة التوصيل',
                    bottomLabel: req.destinationAddress ?? '—'),
              ])),
          SizedBox(height: Insets.s16),
          _section(
              'تفاصيل السيارة',
              Row(children: [
                if (req.plateNumber != null)
                  DetailChip(label: 'رقم اللوحة: ${req.plateNumber}'),
              ])),
          SizedBox(height: Insets.s16),
          _section(
              'تفاصيل مزود الخدمة',
              ProviderInfoCard.fromRequest(req)),
          SizedBox(height: Insets.s16),
          _section(
              'ملخص الدفع',
              TripPaymentSection(
                subtotal: req.subtotal != null
                    ? '${req.subtotal} $cur'
                    : '— $cur',
                serviceFee: req.serviceFee != null
                    ? '${req.serviceFee} $cur'
                    : '— $cur',
                total:
                    req.total != null ? '${req.total} $cur' : '— $cur',
              )),
          SizedBox(height: Sizes.s16),
        ],
      ),
    );
  }

  Widget _section(String title, Widget content) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              textAlign: TextAlign.right),
          SizedBox(height: Insets.s8),
          content,
        ],
      );

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20.sp, color: const Color(0xFF0E0E0E))),
                  Text('تفاصيل الرحلة',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20)),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );
}
