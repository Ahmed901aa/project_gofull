import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'order_address_column.dart';
import 'order_badges_row.dart';
import 'order_price_row.dart';
import 'order_route_connector.dart';

class ActiveOrderCard extends StatelessWidget {
  final ServiceRequestEntity? activeOrder;
  const ActiveOrderCard({super.key, this.activeOrder});

  @override
  Widget build(BuildContext context) {
    final order = activeOrder;
    if (order == null) return const SizedBox.shrink();

    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;
    final address = order.driverAddress ?? 'الموقع الحالي';
    final price = order.total != null
        ? '${double.tryParse(order.total!)?.toStringAsFixed(2) ?? '—'} $cur'
        : '—';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Sizes.s12),
            child: Text('طلبك الحالي',
                style: getSemiBoldStyle(
                    color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                textAlign: TextAlign.right),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral500),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const OrderBadgesRow(),
                _buildRouteCard(address),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.s12),
                  child: Divider(
                      color: AppColors.neutral500, height: 1, thickness: 1),
                ),
                OrderPriceRow(price: price),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(String address) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1))
          ],
        ),
        child: Row(
          children: [
            Expanded(
                child: OrderAddressColumn(
                    label: 'نقطة الانطلاق', address: address)),
            const OrderRouteConnector(),
            Expanded(
                child:
                    OrderAddressColumn(label: 'الحالة', address: _statusAr)),
          ],
        ),
      ),
    );
  }

  String get _statusAr {
    switch (activeOrder?.status) {
      case 'pending':
        return 'في انتظار القبول';
      case 'accepted':
        return 'تم القبول';
      case 'en_route':
        return 'في الطريق';
      case 'arrived':
        return 'وصل';
      case 'in_progress':
        return 'قيد التنفيذ';
      default:
        return 'قيد المعالجة';
    }
  }
}
