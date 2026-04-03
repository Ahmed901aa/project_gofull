import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';

// ── Mock Data ────────────────────────────────────────────
// replace with API data later

enum _ServiceType { tow, fuel }

enum _OrderStatus { completed, cancelled, unrated }

class _DriverOrder {
  final String id;
  final _ServiceType serviceType;
  final _OrderStatus status;
  final String address;
  final String dateTime;
  final String total;
  final String paymentMethod;

  const _DriverOrder({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.address,
    required this.dateTime,
    required this.total,
    required this.paymentMethod,
  });
}

const _mockOrders = [
  _DriverOrder(
    id: 'order_1',
    serviceType: _ServiceType.tow,
    status: _OrderStatus.completed,
    address: 'المنصورة، مدينة مبارك، شارع مكة',
    dateTime: '2025/03/15 - 10:30 ص',
    total: '985.00 ج.م',
    paymentMethod: 'كاش',
  ),
  _DriverOrder(
    id: 'order_2',
    serviceType: _ServiceType.fuel,
    status: _OrderStatus.cancelled,
    address: 'القاهرة، مدينة نصر، شارع عباس العقاد',
    dateTime: '2025/03/14 - 02:15 م',
    total: '320.00 ج.م',
    paymentMethod: 'كاش',
  ),
  _DriverOrder(
    id: 'order_3',
    serviceType: _ServiceType.tow,
    status: _OrderStatus.unrated,
    address: 'الإسكندرية، سيدي جابر، شارع الجمهورية',
    dateTime: '2025/03/13 - 08:45 ص',
    total: '750.00 ج.م',
    paymentMethod: 'كاش',
  ),
  _DriverOrder(
    id: 'order_4',
    serviceType: _ServiceType.fuel,
    status: _OrderStatus.completed,
    address: 'الجيزة، حي الدقي، شارع النيل',
    dateTime: '2025/03/12 - 04:00 م',
    total: '450.00 ج.م',
    paymentMethod: 'كاش',
  ),
  _DriverOrder(
    id: 'order_5',
    serviceType: _ServiceType.tow,
    status: _OrderStatus.cancelled,
    address: 'الرياض، حي النزهة، شارع الأمير',
    dateTime: '2025/03/11 - 11:20 ص',
    total: '650.00 ج.م',
    paymentMethod: 'كاش',
  ),
];

// ── Screen ───────────────────────────────────────────────

class DriverOrdersScreen extends StatelessWidget {
  const DriverOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                itemCount: _mockOrders.length,
                separatorBuilder: (_, __) => Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
                itemBuilder: (context, index) =>
                    _OrderCard(order: _mockOrders[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'الطلبات الأخيرة',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );
}

// ── Order Card ───────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final _DriverOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.driverTripDetails,
        arguments: DriverTripDetailsArgs(
          serviceType: order.serviceType == _ServiceType.tow ? 'tow' : 'fuel',
          orderId: order.id,
          isRated: order.status == _OrderStatus.completed,
        ),
      ),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row: service type + status
            Row(
              children: [
                _ServiceBadge(type: order.serviceType),
                const Spacer(),
                _StatusBadge(status: order.status),
              ],
            ),
            SizedBox(height: Insets.s12),

            // Address
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 18.sp, color: AppColors.grey),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    order.address,
                    style: getRegularStyle(
                        color: AppColors.darkGrey, fontSize: FontSize.s14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.s8),

            // Date / time
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 16.sp, color: AppColors.grey),
                SizedBox(width: 4.w),
                Text(
                  order.dateTime,
                  style: getRegularStyle(
                      color: AppColors.grey, fontSize: FontSize.s12),
                ),
              ],
            ),
            SizedBox(height: Insets.s12),

            // Bottom row: total + payment badge
            Row(
              children: [
                Text(
                  'الإجمالي',
                  style: getRegularStyle(
                      color: AppColors.grey, fontSize: FontSize.s14),
                ),
                SizedBox(width: 4.w),
                Text(
                  order.total,
                  style: getBoldStyle(
                      color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 14.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        order.paymentMethod,
                        style: getMediumStyle(
                            color: AppColors.primary, fontSize: FontSize.s12),
                      ),
                    ],
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

// ── Badges ───────────────────────────────────────────────

class _ServiceBadge extends StatelessWidget {
  final _ServiceType type;
  const _ServiceBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final isTow = type == _ServiceType.tow;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
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
            isTow ? Icons.fire_truck_rounded : Icons.local_gas_station_rounded,
            size: 14.sp,
            color: isTow ? AppColors.primary : AppColors.gold,
          ),
          SizedBox(width: 4.w),
          Text(
            isTow ? 'خدمة ونش' : 'خدمة وقود',
            style: getMediumStyle(
              color: isTow ? AppColors.primary : AppColors.gold,
              fontSize: FontSize.s12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case _OrderStatus.completed:
        bg = AppColors.success.withValues(alpha: 0.1);
        fg = AppColors.success;
        label = 'مكتمل';
      case _OrderStatus.cancelled:
        bg = AppColors.error.withValues(alpha: 0.1);
        fg = AppColors.error;
        label = 'ملغي';
      case _OrderStatus.unrated:
        bg = AppColors.gold.withValues(alpha: 0.1);
        fg = AppColors.gold;
        label = 'غير مقيّم';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Text(
        label,
        style: getMediumStyle(color: fg, fontSize: FontSize.s12),
      ),
    );
  }
}

