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
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Service icon (green circle)
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Icon(
                isFuel
                    ? Icons.local_gas_station_rounded
                    : Icons.fire_truck_rounded,
                color: Colors.white,
                size: 26.sp,
              ),
            ),
            SizedBox(width: Insets.s12),

            // Middle: title + live dot + progress bar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isFuel ? l10n.fuelOnItsWay : l10n.towOnItsWay,
                          style: getBoldStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                      // Live dot
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Insets.s8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: statusInfo.progress,
                      backgroundColor: context.colors.primary.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                      minHeight: 6.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Insets.s12),

            // ETA on the right
            Column(
              children: [
                Text(
                  '8',
                  style: getBoldStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s20,
                  ),
                ),
                Text(
                  l10n.minutes,
                  style: getRegularStyle(
                    color: context.colors.textSecondary,
                    fontSize: FontSize.s10,
                  ),
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
