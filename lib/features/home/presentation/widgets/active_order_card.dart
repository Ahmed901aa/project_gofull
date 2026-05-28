import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Banner shown on the customer home screen when there's an active order.
/// Tap → resume the order on the correct screen based on its status.
class ActiveOrderCard extends StatelessWidget {
  final ServiceRequestEntity? activeOrder;
  final VoidCallback? onCancelled;
  const ActiveOrderCard({super.key, this.activeOrder, this.onCancelled});

  @override
  Widget build(BuildContext context) {
    final order = activeOrder;
    if (order == null) {

      return const SizedBox.shrink();

    }

    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;
    final l10n = S.of(context);
    final address = order.driverAddress ?? l10n.currentLocation;
    final price = order.total != null
        ? '${double.tryParse(order.total!)?.toStringAsFixed(2) ?? '—'} $cur'
        : '—';
    final isFuel = order.isFuelDelivery;
    // Only allow cancel while the order is still pending.
    // Once the driver has accepted, the customer must let the service proceed.
    final canCancel = order.status.trim().toLowerCase() == 'pending';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Sizes.s12),
            child: Text(l10n.currentOrder,
                style: getSemiBoldStyle(
                    color: context.colors.textPrimary, fontSize: FontSize.s18),
                textAlign: TextAlign.start),
          ),
          InkWell(
            onTap: () => _resumeOrder(context, order),
            borderRadius: BorderRadius.circular(AppRadius.s16),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.s16),
                border: Border.all(color: context.colors.primary, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Service badge + status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Insets.s12, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.s16),
                        ),
                        child: Text(
                          isFuel ? l10n.fuelService : l10n.towService,
                          style: getSemiBoldStyle(
                              color: context.colors.primary,
                              fontSize: FontSize.s12),
                        ),
                      ),
                      _StatusBadge(status: order.status),
                    ],
                  ),
                  SizedBox(height: Insets.s12),

                  // Address
                  Row(children: [
                    Icon(Icons.location_on_rounded,
                        size: 18.sp, color: context.colors.primary),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(address,
                          style: getMediumStyle(
                              color: context.colors.textPrimary,
                              fontSize: FontSize.s14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  SizedBox(height: Insets.s12),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.total,
                          style: getRegularStyle(
                              color: context.colors.textSecondary,
                              fontSize: FontSize.s14)),
                      Text(price,
                          style: getBoldStyle(
                              color: context.colors.primary,
                              fontSize: FontSize.s16)),
                    ],
                  ),
                  SizedBox(height: Insets.s16),

                  // Action row: Resume + Cancel
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42.h,
                          child: ElevatedButton(
                            onPressed: () => _resumeOrder(context, order),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.primary,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.s12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l10n.resumeOrder,
                                    style: getSemiBoldStyle(
                                        color: context.colors.surface,
                                        fontSize: FontSize.s14)),
                                SizedBox(width: 6.w),
                                Icon(Icons.arrow_forward_rounded,
                                    size: 22.sp,
                                    color: context.colors.surface,
                                    textDirection: TextDirection.ltr),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (canCancel) ...[
                        SizedBox(width: Insets.s8),
                        SizedBox(
                          height: 42.h,
                          child: OutlinedButton(
                            onPressed: () =>
                                _confirmCancel(context, order.id),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: context.colors.error),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.s12),
                              ),
                            ),
                            child: Text(l10n.cancel,
                                style: getSemiBoldStyle(
                                    color: context.colors.error,
                                    fontSize: FontSize.s14)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to the correct screen for the current order status.
  void _resumeOrder(BuildContext context, ServiceRequestEntity order) {
    final l10n = S.of(context);
    final isFuel = order.isFuelDelivery;
    final status = order.status.trim().toLowerCase();

    switch (status) {
      case 'pending':
        Navigator.pushNamed(
          context,
          Routes.searchingDriver,
          arguments: SearchingArgs(
            searchingText: isFuel
                ? l10n.searchingForFuelProvider
                : l10n.searchingForTowDriver,
            subtitleText: isFuel
                ? l10n.searchingFuelSubtitle
                : l10n.searchingTowSubtitle,
            nextRoute: Routes.driverFound,
            requestId: order.id,
            serviceType:
                isFuel ? 'fuel_delivery' : 'towing',
          ),
        );
        break;

      case 'accepted':
      case 'en_route':
        Navigator.pushNamed(
          context,
          Routes.driverFound,
          arguments: DriverFoundArgs(
            title: isFuel
                ? l10n.fuelProviderFound
                : l10n.towTruckFound,
            vehicleLabel: l10n.vehicleLabel,
            vehicleValue: isFuel ? l10n.fuelSupplyVehicle : l10n.hydraulicTowTruck,
            showClose: true,
            imagePath: isFuel
                ? 'assets/images/tank_truck.gif'
                : 'assets/images/magnifying_glass.gif',
            nextRoute:
                isFuel ? Routes.serviceArrived : Routes.towingStarted,
            requestId: order.id,
            serviceType: isFuel ? 'fuel_delivery' : 'towing',
          ),
        );
        break;

      case 'arrived':
      case 'in_progress':
        if (isFuel) {
          Navigator.pushNamed(
            context,
            Routes.serviceArrived,
            arguments: ServiceArrivedArgs(requestId: order.id),
          );
        } else {
          Navigator.pushNamed(
            context,
            Routes.tripInProgress,
            arguments: TripInProgressArgs(
              originAddress: order.driverAddress ?? '',
              destinationAddress: order.destinationAddress ?? '',
              requestId: order.id,
            ),
          );
        }
        break;
    }
  }

  void _confirmCancel(BuildContext context, int orderId) async {
    final l10n = S.of(context);
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.cancel_rounded,
      iconColor: context.colors.error,
      title: l10n.cancelOrderConfirmTitle,
      subtitle: l10n.cancelOrderCustomerConfirm,
      confirmLabel: l10n.yesCancel,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (confirmed && context.mounted) {
      _cancelOrder(context, orderId);
    }
  }

  void _cancelOrder(BuildContext context, int orderId) {
    final bloc = sl<RequestBloc>()..add(CancelRequestEvent(orderId));
    bloc.stream.listen((state) {
      if (state is RequestCancelled) {
        onCancelled?.call();
        if (context.mounted) {
          AppSnackbar.success(context, S.of(context).orderCancelledSuccess);
        }
      }
    });
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final info = _info(context, status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: info.bg,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: info.fg,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            info.label,
            style: getMediumStyle(color: info.fg, fontSize: FontSize.s12),
          ),
        ],
      ),
    );
  }

  _StatusInfo _info(BuildContext context, String s) {
    final l10n = S.of(context);
    switch (s.trim().toLowerCase()) {
      case 'pending':
        return _StatusInfo(
            l10n.pendingAcceptance, context.colors.warning, context.colors.warningSurface);
      case 'accepted':
        return _StatusInfo(
            l10n.orderAccepted, context.colors.info, context.isDarkMode ? const Color(0xFF1A2E3A) : const Color(0xFFE3F2FD));
      case 'en_route':
        return _StatusInfo(
            l10n.enRoute, context.colors.success, context.colors.successSurface);
      case 'arrived':
        return _StatusInfo(
            l10n.arrived, context.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF0C5460), context.isDarkMode ? const Color(0xFF1A3A35) : const Color(0xFFD1ECF1));
      case 'in_progress':
        return _StatusInfo(l10n.inProgress, context.isDarkMode ? const Color(0xFFCE93D8) : const Color(0xFF4A148C),
            context.isDarkMode ? const Color(0xFF2A1A3A) : const Color(0xFFE2D5F1));
      default:
        return _StatusInfo(
            l10n.processing, context.colors.textSecondary, context.colors.surfaceElevated);
    }
  }
}

class _StatusInfo {
  final String label;
  final Color fg;
  final Color bg;
  _StatusInfo(this.label, this.fg, this.bg);
}
