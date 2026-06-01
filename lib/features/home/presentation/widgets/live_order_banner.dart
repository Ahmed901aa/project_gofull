import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Live status card shown in place of the promo banner when there's an active order.
/// Styled like a compact tracking card with icon, status text, progress bar, and ETA.
class LiveOrderBanner extends StatelessWidget {
  final ServiceRequestEntity order;
  final VoidCallback onTap;

  const LiveOrderBanner({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final isFuel = order.isFuelDelivery;
    final statusInfo = _getStatusInfo(context, order.status, isFuel);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colors.primary,
              context.colors.primaryLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.s16),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + title + live badge
            Row(
              children: [
                // Service icon
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  child: Icon(
                    isFuel
                        ? Icons.local_gas_station_rounded
                        : Icons.fire_truck_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: Insets.s12),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFuel
                            ? l10n.fuelOnItsWay
                            : l10n.towOnItsWay,
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        statusInfo.subtitle,
                        style: getRegularStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Live badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        l10n.live,
                        style: getMediumStyle(
                          color: Colors.white,
                          fontSize: FontSize.s10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.s16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: statusInfo.progress,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6.h,
              ),
            ),
            SizedBox(height: Insets.s8),

            // Bottom row: status label + tap to view
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusInfo.label,
                  style: getMediumStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: FontSize.s12,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.tapToView,
                      style: getMediumStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: FontSize.s12,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 12.sp,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _OrderStatusInfo _getStatusInfo(
      BuildContext context, String status, bool isFuel) {
    final l10n = S.of(context);
    switch (status.trim().toLowerCase()) {
      case 'pending':
        return _OrderStatusInfo(
          label: l10n.pendingAcceptance,
          subtitle: isFuel
              ? l10n.searchingForFuelProvider
              : l10n.searchingForTowDriver,
          progress: 0.15,
        );
      case 'accepted':
        return _OrderStatusInfo(
          label: l10n.orderAccepted,
          subtitle: l10n.driverPreparingToArrive,
          progress: 0.35,
        );
      case 'en_route':
        return _OrderStatusInfo(
          label: l10n.enRoute,
          subtitle: isFuel ? l10n.fuelOnItsWay : l10n.towOnItsWay,
          progress: 0.55,
        );
      case 'arrived':
        return _OrderStatusInfo(
          label: l10n.arrived,
          subtitle: l10n.driverArrivedAtLocation,
          progress: 0.75,
        );
      case 'in_progress':
        return _OrderStatusInfo(
          label: l10n.inProgress,
          subtitle: isFuel ? l10n.fuelingInProgress : l10n.towingInProgress,
          progress: 0.9,
        );
      default:
        return _OrderStatusInfo(
          label: l10n.processing,
          subtitle: '',
          progress: 0.1,
        );
    }
  }
}

class _OrderStatusInfo {
  final String label;
  final String subtitle;
  final double progress;
  const _OrderStatusInfo({
    required this.label,
    required this.subtitle,
    required this.progress,
  });
}
