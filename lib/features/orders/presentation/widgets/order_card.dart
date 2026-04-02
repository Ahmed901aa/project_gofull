import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/presentation/widgets/order_address_column.dart';
import 'package:project_gofull/features/home/presentation/widgets/order_price_row.dart';
import 'package:project_gofull/features/home/presentation/widgets/order_route_connector.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'order_detail_row.dart';

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
            _buildBadgesRow(),
            SizedBox(height: Sizes.s8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: order.serviceType == ServiceType.tow
                  ? _buildRouteCard()
                  : _buildFuelLocationRow(),
            ),
            SizedBox(height: Sizes.s8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: _buildDetailRows(),
            ),
            SizedBox(height: Sizes.s8),
            Divider(color: AppColors.neutral500, height: 1, thickness: 1),
            SizedBox(height: Sizes.s8),
            OrderPriceRow(price: order.price),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ServiceBadge(serviceType: order.serviceType),
          _StatusBadge(status: order.status),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: EdgeInsets.all(Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OrderAddressColumn(
              label: 'وجهة التوصيل',
              address: order.toAddress ?? '',
            ),
          ),
          const OrderRouteConnector(),
          Expanded(
            child: OrderAddressColumn(
              label: 'نقطة الانطلاق',
              address: order.fromAddress ?? '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelLocationRow() {
    return Container(
      padding: EdgeInsets.all(Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'موقع السيارة',
            style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s12),
          ),
          SizedBox(height: 2.h),
          Text(
            order.location ?? '',
            style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRows() {
    final rows = order.serviceType == ServiceType.tow
        ? [
            OrderDetailRow(label: 'نوع السيارة', value: order.carType),
            OrderDetailRow(label: 'رقم اللوحة', value: order.plateNumber),
            OrderDetailRow(label: 'نوع الونش', value: order.winchType ?? ''),
          ]
        : [
            OrderDetailRow(label: 'نوع الوقود', value: order.fuelType ?? ''),
            OrderDetailRow(label: 'الكمية', value: order.quantity ?? ''),
            OrderDetailRow(label: 'نوع المركبة', value: order.carType),
            OrderDetailRow(label: 'رقم اللوحة', value: order.plateNumber),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  final ServiceType serviceType;
  const _ServiceBadge({required this.serviceType});

  @override
  Widget build(BuildContext context) {
    final label = serviceType == ServiceType.tow ? 'خدمة ونش' : 'إمداد وقود';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          serviceType == ServiceType.tow
              ? SvgPicture.asset('assets/svg/towing.svg', width: 14.sp, height: 14.sp, colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn))
              : Icon(Icons.local_gas_station_outlined, size: 14.sp, color: AppColors.white),
          SizedBox(width: 4.w),
          Text(label, style: getMediumStyle(color: AppColors.white, fontSize: FontSize.s12)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case OrderStatus.active:
        bgColor = const Color(0xFFF2F3F4);
        textColor = const Color(0xFF0E0E0E);
        label = 'قيد التنفيذ';
      case OrderStatus.cancelled:
        bgColor = const Color(0xFFFDECEA);
        textColor = const Color(0xFFD32F2F);
        label = 'ملغي';
      case OrderStatus.completed:
        bgColor = const Color(0xFFF2F3F4);
        textColor = const Color(0xFF646565);
        label = 'منتهي';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Text(label, style: getMediumStyle(color: textColor, fontSize: FontSize.s12)),
    );
  }
}
