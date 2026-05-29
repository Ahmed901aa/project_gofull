import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/provider_info_card.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/trip_fuel_chips.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/trip_location_card.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/trip_payment_card.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripDetailsArgs? args;
  const TripDetailsScreen({super.key, this.args});

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
        backgroundColor: context.colors.background,
        body: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            Widget body;
            if (state is RequestLoading) {
              body = Center(
                  child: CircularProgressIndicator(color: context.colors.primary));
            } else if (state is RequestDetailsLoaded) {
              body = _buildContent(context, state.request);
            } else if (state is RequestError) {
              body = Center(
                  child: Text(state.message,
                      style: getRegularStyle(
                          color: context.colors.iconSecondary, fontSize: FontSize.s14)));
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

  Widget _buildContent(BuildContext context, ServiceRequestEntity req) {
    final l10n = S.of(context);
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    // Fuel info
    final fuelTypeMap = {'petrol': l10n.gasolineFuel, 'diesel': l10n.dieselFuel};
    final fuelType = fuelTypeMap[req.fuelType] ?? req.fuelType ?? '—';
    final quantity =
        req.fuelQuantity != null ? '${req.fuelQuantity} ${l10n.litersUnit}' : '—';

    // Rating info
    final ratingInfo = req.ratingInfo;
    final ratingValue = ratingInfo?['rating']?.toString();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Insets.s16),
          _section(context,
              l10n.location, TripLocationCard(address: req.driverAddress ?? '—')),
          SizedBox(height: Insets.s16),
          _section(context, l10n.fuelDetails,
              TripFuelChips(fuelType: fuelType, quantity: quantity)),
          SizedBox(height: Insets.s16),
          _section(context,
            l10n.providerDetails,
            ProviderInfoCard.fromRequest(
              req,
              onCall: () {
                final userInfo =
                    (req.providerInfo?['user'] as Map<String, dynamic>?) ?? {};
                final phone = userInfo['phone'] as String?;
                if (phone != null && phone.isNotEmpty) {
                  launchUrl(Uri.parse('tel:$phone'));
                }
              },
            ),
          ),
          SizedBox(height: Insets.s16),
          _section(context,
            l10n.paymentSummary,
            TripPaymentCard(
              subtotal:
                  req.subtotal != null ? '${req.subtotal} $cur' : '— $cur',
              serviceFee: req.serviceFee != null
                  ? '${req.serviceFee} $cur'
                  : '${config.serviceFee.toStringAsFixed(2)} $cur',
              total: req.total != null ? '${req.total} $cur' : '— $cur',
            ),
          ),
          if (ratingValue != null) ...[
            SizedBox(height: Insets.s16),
            _section(context,
              l10n.yourRating,
              Container(
                padding: EdgeInsets.all(Insets.s16),
                decoration: BoxDecoration(
                  color: context.colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                  border: Border.all(color: context.colors.border),
                ),
                child: Row(children: [
                  Icon(Icons.star_rounded,
                      size: 24.sp, color: context.colors.gold),
                  SizedBox(width: 8.w),
                  Text('$ratingValue / 5',
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s18)),
                  if (ratingInfo?['comment'] != null) ...[
                    SizedBox(width: Insets.s12),
                    Expanded(
                      child: Text(ratingInfo!['comment'].toString(),
                          style: getRegularStyle(
                              color: context.colors.textSecondary,
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

  Widget _section(BuildContext context, String title, Widget content) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s18),
              textAlign: TextAlign.start),
          SizedBox(height: Insets.s8),
          content,
        ],
      );

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
                    child: Icon(backArrowIcon(context),
                        size: 20.sp, color: context.colors.textPrimary)),
                Text(S.of(context).driverTripDetails,
                    style: getBoldStyle(
                        color: context.colors.textPrimary,
                        fontSize: FontSize.s20)),
                SizedBox(width: 24.sp),
              ],
            ),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ]),
      );
}
