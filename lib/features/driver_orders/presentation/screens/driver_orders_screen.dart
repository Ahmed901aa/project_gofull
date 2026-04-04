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
  final String date;
  final bool isCompleted;
  final String amount;

  const _OrderItem({
    required this.orderId,
    required this.serviceType,
    required this.date,
    required this.isCompleted,
    required this.amount,
  });
}

class DriverOrdersScreen extends StatelessWidget {
  const DriverOrdersScreen({super.key});

  static const List<_OrderItem> _mockOrders = [
    _OrderItem(
      orderId: '#1234',
      serviceType: 'tow',
      date: '7 أغسطس 2024',
      isCompleted: true,
      amount: '150 ج.م',
    ),
    _OrderItem(
      orderId: '#1235',
      serviceType: 'fuel',
      date: '6 أغسطس 2024',
      isCompleted: true,
      amount: '85 ج.م',
    ),
    _OrderItem(
      orderId: '#1236',
      serviceType: 'tow',
      date: '5 أغسطس 2024',
      isCompleted: false,
      amount: '200 ج.م',
    ),
    _OrderItem(
      orderId: '#1237',
      serviceType: 'fuel',
      date: '3 أغسطس 2024',
      isCompleted: true,
      amount: '120 ج.م',
    ),
    _OrderItem(
      orderId: '#1238',
      serviceType: 'tow',
      date: '1 أغسطس 2024',
      isCompleted: false,
      amount: '180 ج.م',
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
              itemBuilder: (_, index) => _buildOrderCard(context, _mockOrders[index]),
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
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isTow
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Icon(
                isTow ? Icons.local_shipping_outlined : Icons.local_gas_station_outlined,
                size: 24.sp,
                color: isTow ? AppColors.primary : AppColors.gold,
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isTow ? AppStrings.towService : AppStrings.fuelService,
                        style: getSemiBoldStyle(
                          color: AppColors.black,
                          fontSize: FontSize.s16,
                        ),
                      ),
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
                  SizedBox(height: Sizes.s4),
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
                  SizedBox(height: Sizes.s4),
                  Text(
                    order.date,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
