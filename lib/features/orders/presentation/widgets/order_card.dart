import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/presentation/widgets/order_price_row.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'order_detail_row.dart';
import 'service_badge.dart';
import 'status_badge.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Maps a raw fuel-type value (from the backend or mock data) to a localized
/// label. The backend may send `'petrol'`, `'gasoline'`, `'diesel'`, etc.;
/// some mocks send Arabic strings (`'بنزين 95'`, `'ديزل'`). In every case the
/// label shown to the user follows the current locale, while the underlying
/// value sent to the backend stays unchanged.
String _localizedFuelType(BuildContext context, String? raw) {
  if (raw == null || raw.trim().isEmpty) return '';
  final l10n = S.of(context);
  final lower = raw.toLowerCase();
  if (lower.contains('diesel') || raw.contains('ديزل')) {
    return l10n.dieselFuel;
  }
  if (lower.contains('petrol') ||
      lower.contains('gasoline') ||
      lower.contains('benzin') ||
      raw.contains('بنزين')) {
    return l10n.gasolineFuel;
  }
  return raw;
}

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
          color: context.colors.background,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceBadge(serviceType: order.serviceType),
                  StatusBadge(status: order.status),
                ],
              ),
            ),
            SizedBox(height: Sizes.s8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: order.serviceType == ServiceType.tow ? _buildRouteCard(context) : _buildFuelLocationRow(context),
            ),
            SizedBox(height: Sizes.s8),
            Padding(padding: EdgeInsets.symmetric(horizontal: Insets.s16), child: _buildDetailRows(context)),
            SizedBox(height: Sizes.s8),
            Divider(color: context.colors.border, height: 1, thickness: 1),
            SizedBox(height: Sizes.s8),
            OrderPriceRow(price: order.price),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: context.colors.background, borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
          boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(children: [
          Icon(Icons.location_on_rounded, size: 20.sp, color: context.colors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(S.of(context).deliveryDestinationAlt, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12)),
              SizedBox(height: 2.h),
              Text(order.toAddress ?? '', style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s12), maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
      );

  Widget _buildFuelLocationRow(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: context.colors.background, borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
          boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Icon(Icons.location_on_rounded, size: 20.sp, color: context.colors.primary),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(S.of(context).carLocationLabel, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12)),
                SizedBox(height: 2.h),
                Text(order.location ?? '', style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s12), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
          if (order.fuelType != null && order.fuelType!.isNotEmpty) ...[
            Divider(color: context.colors.border, height: 16.h),
            Row(children: [
              Icon(Icons.local_gas_station_rounded, size: 20.sp, color: context.colors.primary),
              SizedBox(width: 8.w),
              Text(S.of(context).fuelTypeLabel, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12)),
              Text(_localizedFuelType(context, order.fuelType), style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s12)),
              if (order.quantity != null && order.quantity!.isNotEmpty) ...[
                SizedBox(width: 12.w),
                Text(S.of(context).quantityLabel, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12)),
                Text(order.quantity!, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s12)),
              ],
            ]),
          ],
        ]),
      );

  Widget _buildDetailRows(BuildContext context) {
    final rows = order.serviceType == ServiceType.tow
        ? [OrderDetailRow(label: S.of(context).carTypeLabel, value: order.carType), OrderDetailRow(label: S.of(context).plateNumberLabel, value: order.plateNumber), OrderDetailRow(label: S.of(context).towTruckType, value: order.winchType ?? '')]
        : [OrderDetailRow(label: S.of(context).fuelType, value: _localizedFuelType(context, order.fuelType)), OrderDetailRow(label: S.of(context).fuelQuantity, value: order.quantity ?? ''), OrderDetailRow(label: S.of(context).vehicleTypeLabel, value: order.carType), OrderDetailRow(label: S.of(context).plateNumberLabel, value: order.plateNumber)];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }
}
