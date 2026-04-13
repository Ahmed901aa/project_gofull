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
import 'package:project_gofull/core/widgets/service_location_card.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/detail_chip.dart';
import 'package:project_gofull/features/towing/presentation/widgets/trip_payment_section.dart';

class TowingTripDetailsScreen extends StatelessWidget {
  final TripDetailsArgs? args;
  const TowingTripDetailsScreen({super.key, this.args});

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
        body: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            Widget body;
            if (state is RequestLoading) {
              body = const Center(
                  child: CircularProgressIndicator(color: AppColors.primary));
            } else if (state is RequestDetailsLoaded) {
              body = _buildBody(context, state.request);
            } else if (state is RequestError) {
              body = Center(
                  child: Text(state.message,
                      style: getRegularStyle(
                          color: AppColors.grey, fontSize: FontSize.s14)));
            } else {
              body = const SizedBox.shrink();
            }

            return Column(children: [
              _buildHeader(context),
              Expanded(child: body),
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ServiceRequestEntity req) {
    final cur = context.read<AppConfigBloc>().state.currency;

    // Rating info
    final ratingInfo = req.ratingInfo;
    final ratingValue = ratingInfo?['rating']?.toString();

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
            ]),
          ),
          SizedBox(height: Insets.s16),
          _section(
            'تفاصيل السيارة',
            Row(children: [
              if (req.carType != null)
                DetailChip(label: 'نوع السيارة: ${req.carType}'),
              if (req.carType != null && req.plateNumber != null)
                SizedBox(width: Sizes.s8),
              if (req.plateNumber != null)
                DetailChip(label: 'رقم اللوحة: ${req.plateNumber}'),
            ]),
          ),
          SizedBox(height: Insets.s16),
          _section(
            'تفاصيل مزود الخدمة',
            ProviderInfoCard.fromRequest(req),
          ),
          SizedBox(height: Insets.s16),
          _section(
            'ملخص الدفع',
            TripPaymentSection(
              subtotal:
                  req.subtotal != null ? '${req.subtotal} $cur' : '— $cur',
              serviceFee: req.serviceFee != null
                  ? '${req.serviceFee} $cur'
                  : '— $cur',
              total: req.total != null ? '${req.total} $cur' : '— $cur',
            ),
          ),
          if (ratingValue != null) ...[
            SizedBox(height: Insets.s16),
            _section(
              'تقييمك',
              Container(
                padding: EdgeInsets.all(Insets.s16),
                decoration: BoxDecoration(
                  color: AppColors.neutral400,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                  border: Border.all(color: AppColors.neutral500),
                ),
                child: Row(children: [
                  Icon(Icons.star_rounded,
                      size: 24.sp, color: const Color(0xFFFFB800)),
                  SizedBox(width: 8.w),
                  Text('$ratingValue / 5',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s18)),
                  if (ratingInfo?['comment'] != null) ...[
                    SizedBox(width: Insets.s12),
                    Expanded(
                      child: Text(ratingInfo!['comment'].toString(),
                          style: getRegularStyle(
                              color: AppColors.neutral800,
                              fontSize: FontSize.s14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ]),
              ),
            ),
          ],
          SizedBox(height: Insets.s16),
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
