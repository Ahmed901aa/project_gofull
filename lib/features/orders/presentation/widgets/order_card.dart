import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/presentation/widgets/order_address_column.dart';
import 'package:project_gofull/features/home/presentation/widgets/order_price_row.dart';
import 'package:project_gofull/features/home/presentation/widgets/order_route_connector.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'order_detail_row.dart';
import 'service_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderData order;
  final VoidCallback onTap;
  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ServiceBadge(serviceType: order.serviceType)],
              ),
            ),
            SizedBox(height: Sizes.s8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: order.serviceType == ServiceType.tow ? _buildRouteCard() : _buildFuelLocationRow(),
            ),
            SizedBox(height: Sizes.s8),
            Padding(padding: EdgeInsets.symmetric(horizontal: Insets.s16), child: _buildDetailRows()),
            SizedBox(height: Sizes.s8),
            Divider(color: AppColors.neutral500, height: 1, thickness: 1),
            SizedBox(height: Sizes.s8),
            OrderPriceRow(price: order.price),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard() => Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(children: [
          Expanded(child: OrderAddressColumn(label: 'وجهة التوصيل', address: order.toAddress ?? '')),
          const OrderRouteConnector(),
          Expanded(child: OrderAddressColumn(label: 'نقطة الانطلاق', address: order.fromAddress ?? '')),
        ]),
      );

  Widget _buildFuelLocationRow() => Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('موقع السيارة', style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s12)),
          SizedBox(height: 2.h),
          Text(order.location ?? '', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s12), maxLines: 2, overflow: TextOverflow.ellipsis),
        ]),
      );

  Widget _buildDetailRows() {
    final rows = order.serviceType == ServiceType.tow
        ? [OrderDetailRow(label: 'نوع السيارة', value: order.carType), OrderDetailRow(label: 'رقم اللوحة', value: order.plateNumber), OrderDetailRow(label: 'نوع الونش', value: order.winchType ?? '')]
        : [OrderDetailRow(label: 'نوع الوقود', value: order.fuelType ?? ''), OrderDetailRow(label: 'الكمية', value: order.quantity ?? ''), OrderDetailRow(label: 'نوع المركبة', value: order.carType), OrderDetailRow(label: 'رقم اللوحة', value: order.plateNumber)];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }
}
