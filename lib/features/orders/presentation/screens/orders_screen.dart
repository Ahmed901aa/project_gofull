import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';

import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/orders/presentation/widgets/order_card.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequestBloc>()..add(const LoadRequestsEvent()),
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<RequestBloc, RequestState>(
                builder: (context, state) {
                  if (state is RequestLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: context.colors.primary));
                  }
                  if (state is RequestError) {
                    return Center(
                        child: Text(state.message,
                            style: getRegularStyle(
                                color: context.colors.iconSecondary,
                                fontSize: FontSize.s16)));
                  }
                  if (state is RequestsLoaded) {
                    return _buildOrderList(context, state.requests);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
      BuildContext context, List<ServiceRequestEntity> requests) {
    if (requests.isEmpty) {
      return Center(
          child: Text(S.of(context).noOrdersYet,
              style: getRegularStyle(
                  color: context.colors.iconSecondary, fontSize: FontSize.s16)));
    }

    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    return RefreshIndicator(
      color: context.colors.primary,
      onRefresh: () async {
        context.read<RequestBloc>().add(const LoadRequestsEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: EdgeInsets.all(Insets.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: Sizes.s8),
            ...requests.map((r) => Padding(
                  padding: EdgeInsets.only(bottom: Insets.s16),
                  child: _buildCard(context, r, cur),
                )),
            SizedBox(height: Sizes.s16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, ServiceRequestEntity req, String cur) {
    final price = req.total != null ? '${req.total} $cur' : '—';
    final status = req.isCompleted
        ? OrderStatus.completed
        : req.isCancelled
            ? OrderStatus.cancelled
            : OrderStatus.active;
    final route =
        req.isFuelDelivery ? Routes.tripDetails : Routes.towingTripDetails;

    final order = OrderData(
      id: req.id.toString(),
      serviceType: req.isFuelDelivery ? ServiceType.fuel : ServiceType.tow,
      status: status,
      price: price,
      isRated: req.isRated,
      fromAddress: req.driverAddress,
      toAddress: req.destinationAddress,
      location: req.driverAddress,
      fuelType: req.fuelType,
      quantity: req.fuelQuantity != null ? '${req.fuelQuantity} ${S.of(context).liters}' : null,
      carType: '',
      plateNumber: req.plateNumber ?? '',
    );

    return OrderCard(
      order: order,
      onTap: () => Navigator.pushNamed(context, route,
          arguments: TripDetailsArgs(
              orderId: req.id.toString(),
              status: status,
              isRated: req.isRated)),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Center(
                child: Text(S.of(context).myOrders,
                    style: getBoldStyle(
                        color: context.colors.textPrimary,
                        fontSize: FontSize.s20))),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ]),
      );
}
