import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/orders/presentation/widgets/order_card.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequestBloc>()..add(const LoadRequestsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<RequestBloc, RequestState>(
                builder: (context, state) {
                  if (state is RequestLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary));
                  }
                  if (state is RequestError) {
                    return Center(
                        child: Text(state.message,
                            style: getRegularStyle(
                                color: AppColors.grey,
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
          child: Text('لا توجد طلبات حتى الآن',
              style: getRegularStyle(
                  color: AppColors.grey, fontSize: FontSize.s16)));
    }

    final active = requests.where((r) => r.isActive).toList();
    final past = requests.where((r) => !r.isActive).toList();
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    return RefreshIndicator(
      color: AppColors.primary,
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
            if (active.isNotEmpty) ...[
              SizedBox(height: Sizes.s8),
              _sectionTitle('الطلب الحالي'),
              SizedBox(height: Sizes.s8),
              ...active.map((r) => Padding(
                    padding: EdgeInsets.only(bottom: Insets.s16),
                    child: _buildCard(context, r, cur),
                  )),
            ],
            if (past.isNotEmpty) ...[
              SizedBox(height: Sizes.s8),
              _sectionTitle('الطلبات السابقة'),
              SizedBox(height: Sizes.s8),
              ...past.map((r) => Padding(
                    padding: EdgeInsets.only(bottom: Insets.s16),
                    child: _buildCard(context, r, cur),
                  )),
            ],
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
      toAddress: null,
      location: req.driverAddress,
      fuelType: req.fuelType,
      quantity: req.fuelQuantity != null ? '${req.fuelQuantity} لتر' : null,
      plateNumber: req.plateNumber,
    );

    return OrderCard(
      order: order,
      onTap: () => Navigator.pushNamed(context, route,
          arguments:
              TripDetailsArgs(orderId: req.id.toString(), status: status)),
    );
  }

  Widget _sectionTitle(String title) => Text(title,
      style: getBoldStyle(
          color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
      textAlign: TextAlign.right);

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Center(
                child: Text('طلباتي',
                    style: getBoldStyle(
                        color: const Color(0xFF0E0E0E),
                        fontSize: FontSize.s20))),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );
}
