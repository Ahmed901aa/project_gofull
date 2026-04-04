import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/service_header.dart';

class _OrderItem {
  final String orderId;
  final String serviceType;
  final String status;
  final String date;
  final String time;
  final String address;
  final String amount;

  const _OrderItem({
    required this.orderId,
    required this.serviceType,
    required this.status,
    required this.date,
    required this.time,
    required this.address,
    required this.amount,
  });

  bool get isCompleted => status == 'completed';
}

class DriverOrdersScreen extends StatelessWidget {
  const DriverOrdersScreen({super.key});

  static const List<_OrderItem> _mockOrders = [
    _OrderItem(
      orderId: '#1234',
      serviceType: 'tow',
      status: 'completed',
      date: '7 أغسطس 2024',
      time: '02:30 م',
      address: 'شارع التحرير، وسط البلد، القاهرة',
      amount: '150 ج.م',
    ),
    _OrderItem(
      orderId: '#1235',
      serviceType: 'fuel',
      status: 'completed',
      date: '6 أغسطس 2024',
      time: '11:15 ص',
      address: 'طريق النصر، مدينة نصر، القاهرة',
      amount: '85 ج.م',
    ),
    _OrderItem(
      orderId: '#1236',
      serviceType: 'tow',
      status: 'cancelled',
      date: '5 أغسطس 2024',
      time: '08:45 ص',
      address: 'شارع الهرم، الجيزة',
      amount: '200 ج.م',
    ),
    _OrderItem(
      orderId: '#1237',
      serviceType: 'fuel',
      status: 'completed',
      date: '3 أغسطس 2024',
      time: '04:00 م',
      address: 'كورنيش النيل، المعادي، القاهرة',
      amount: '120 ج.م',
    ),
    _OrderItem(
      orderId: '#1238',
      serviceType: 'tow',
      status: 'cancelled',
      date: '1 أغسطس 2024',
      time: '09:20 ص',
      address: 'طريق الأوتوستراد، المقطم، القاهرة',
      amount: '180 ج.م',
    ),
    _OrderItem(
      orderId: '#1239',
      serviceType: 'fuel',
      status: 'completed',
      date: '30 يوليو 2024',
      time: '06:10 م',
      address: 'شارع مصطفى النحاس، مدينة نصر',
      amount: '95 ج.م',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: AppStrings.driverRecentOrders),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              itemCount: _mockOrders.length,
              separatorBuilder: (_, __) => SizedBox(height: Sizes.s12),
              itemBuilder: (_, index) =>
                  _buildOrderCard(context, _mockOrders[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, _OrderItem order) {
    final isTow = order.serviceType == 'tow';
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.driverTripDetails,
          arguments: DriverTripDetailsArgs(
            orderId: order.orderId,
            serviceType: order.serviceType,
            isRated: order.isCompleted,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8,
                    vertical: Insets.s4,
                  ),
                  decoration: BoxDecoration(
                    color: isTow
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTow
                            ? Icons.local_shipping_outlined
                            : Icons.local_gas_station_outlined,
                        size: 16.sp,
                        color: isTow ? AppColors.primary : AppColors.gold,
                      ),
                      SizedBox(width: Insets.s4),
                      Text(
                        isTow ? AppStrings.towService : AppStrings.fuelService,
                        style: getMediumStyle(
                          color: isTow ? AppColors.primary : AppColors.gold,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: order.isCompleted
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Text(
                    order.isCompleted
                        ? AppStrings.completed
                        : AppStrings.cancelled,
                    style: getMediumStyle(
                      color: order.isCompleted
                          ? AppColors.success
                          : AppColors.error,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.s12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14.sp,
                  color: AppColors.grey,
                ),
                SizedBox(width: Insets.s4),
                Text(
                  order.date,
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(width: Insets.s12),
                Icon(
                  Icons.access_time_rounded,
                  size: 14.sp,
                  color: AppColors.grey,
                ),
                SizedBox(width: Insets.s4),
                Text(
                  order.time,
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.s8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: AppColors.grey,
                ),
                SizedBox(width: Insets.s4),
                Expanded(
                  child: Text(
                    order.address,
                    style: getRegularStyle(
                      color: AppColors.neutral800,
                      fontSize: FontSize.s14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.s12),
            Divider(height: 1, color: AppColors.divider),
            SizedBox(height: Sizes.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderId,
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s14,
                  ),
                ),
                Text(
                  order.amount,
                  style: getBoldStyle(
                    color: AppColors.primary,
                    fontSize: FontSize.s16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
