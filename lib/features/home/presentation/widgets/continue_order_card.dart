import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Card shown on the customer home screen whenever there is an active order.
/// Tap "Continue" to jump back into the right step of the order flow.
/// While the order is still `pending` the customer can also cancel it.
class ContinueOrderCard extends StatefulWidget {
  final ServiceRequestEntity order;
  final VoidCallback? onCancelled;

  const ContinueOrderCard({
    super.key,
    required this.order,
    this.onCancelled,
  });

  @override
  State<ContinueOrderCard> createState() => _ContinueOrderCardState();
}

class _ContinueOrderCardState extends State<ContinueOrderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final order = widget.order;
    final isFuel = order.isFuelDelivery;
    final status = order.status.trim().toLowerCase();
    final canCancel = status == 'pending';
    final stepInfo = _stepInfo(context, status, isFuel);
    final serviceTitle = isFuel ? l10n.fuelService : l10n.towService;
    final address = order.driverAddress?.trim().isNotEmpty == true
        ? order.driverAddress!
        : l10n.currentLocation;

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section title + animated live dot
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: Sizes.s8),
            child: Row(
              children: [
                Text(
                  l10n.currentOrder,
                  style: getSemiBoldStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(width: 8.w),
                _LiveDot(controller: _pulse, color: context.colors.success),
                SizedBox(width: 4.w),
                Text(
                  l10n.enRouteStatus,
                  style: getMediumStyle(
                    color: context.colors.success,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          ),

          // Card body
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _resume(context, order),
              borderRadius: BorderRadius.circular(AppRadius.s20),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.s20),
                  border: Border.all(
                    color: context.colors.primary.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(Insets.s14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Row 1: square icon + service title + status pill ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Service icon (square, primary background)
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.topStart,
                              end: AlignmentDirectional.bottomEnd,
                              colors: [
                                context.colors.primary,
                                context.colors.primaryLight,
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(AppRadius.s12),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.primary
                                    .withValues(alpha: 0.30),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DirectionalServiceIcon(
                            isFuel
                                ? Icons.local_gas_station_rounded
                                : Icons.fire_truck_rounded,
                            color: Colors.white,
                            size: 26.sp,
                          ),
                        ),
                        SizedBox(width: Insets.s12),

                        // Service title + step description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                serviceTitle,
                                style: getBoldStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: FontSize.s15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                stepInfo.subtitle,
                                style: getRegularStyle(
                                  color: context.colors.textSecondary,
                                  fontSize: FontSize.s12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Insets.s8),

                        // Status pill
                        _StatusPill(label: stepInfo.label, color: stepInfo.color),
                      ],
                    ),
                    SizedBox(height: Insets.s12),

                    // ── Row 2: address ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.place_rounded,
                            size: 18.sp, color: context.colors.primary),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            address,
                            style: getMediumStyle(
                              color: context.colors.textPrimary,
                              fontSize: FontSize.s13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Insets.s12),

                    // ── Row 3: progress bar ──
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: stepInfo.progress,
                        backgroundColor:
                            context.colors.primary.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            context.colors.primary),
                        minHeight: 6.h,
                      ),
                    ),
                    SizedBox(height: Insets.s12),

                    // ── Row 4: actions ──
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: () => _resume(context, order),
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
                                  Text(
                                    l10n.resumeOrder,
                                    style: getSemiBoldStyle(
                                      color: AppColors.white,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Icon(forwardArrowIcon(context),
                                      size: 18.sp, color: AppColors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (canCancel) ...[
                          SizedBox(width: Insets.s8),
                          SizedBox(
                            height: 44.h,
                            width: 44.h,
                            child: OutlinedButton(
                              onPressed: () =>
                                  _confirmCancel(context, order.id),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                side: BorderSide(
                                    color:
                                        context.colors.error.withValues(alpha: 0.6)),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.s12),
                                ),
                              ),
                              child: Icon(Icons.close_rounded,
                                  size: 20.sp, color: context.colors.error),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step info ───────────────────────────────────────────────

  _StepInfo _stepInfo(BuildContext context, String status, bool isFuel) {
    final l10n = S.of(context);
    switch (status) {
      case 'pending':
        return _StepInfo(
          label: l10n.pendingAcceptance,
          subtitle: isFuel
              ? l10n.searchingForFuelProvider
              : l10n.searchingForTowDriver,
          progress: 0.15,
          color: context.colors.warning,
        );
      case 'accepted':
        return _StepInfo(
          label: l10n.orderAccepted,
          subtitle: l10n.driverPreparingToArrive,
          progress: 0.35,
          color: context.isDarkMode
              ? const Color(0xFF64B5F6)
              : context.colors.info,
        );
      case 'en_route':
        return _StepInfo(
          label: l10n.enRoute,
          subtitle: isFuel ? l10n.fuelOnItsWay : l10n.towOnItsWay,
          progress: 0.55,
          color: context.colors.success,
        );
      case 'arrived':
        return _StepInfo(
          label: l10n.arrived,
          subtitle: l10n.driverArrivedAtLocation,
          progress: 0.78,
          color: context.isDarkMode
              ? const Color(0xFF4DB6AC)
              : const Color(0xFF0C5460),
        );
      case 'in_progress':
        return _StepInfo(
          label: l10n.inProgress,
          subtitle: isFuel ? l10n.fuelingInProgress : l10n.towingInProgress,
          progress: 0.9,
          color: context.isDarkMode
              ? const Color(0xFFCE93D8)
              : const Color(0xFF4A148C),
        );
      default:
        return _StepInfo(
          label: l10n.processing,
          subtitle: '',
          progress: 0.1,
          color: context.colors.textSecondary,
        );
    }
  }

  // ── Navigation ──────────────────────────────────────────────

  void _resume(BuildContext context, ServiceRequestEntity order) {
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
            serviceType: isFuel ? 'fuel_delivery' : 'towing',
          ),
        );
        break;

      case 'accepted':
      case 'en_route':
        Navigator.pushNamed(
          context,
          Routes.driverFound,
          arguments: DriverFoundArgs(
            title: isFuel ? l10n.fuelProviderFound : l10n.towTruckFound,
            vehicleLabel: l10n.vehicleLabel,
            vehicleValue:
                isFuel ? l10n.fuelSupplyVehicle : l10n.hydraulicTowTruck,
            showClose: true,
            imagePath: isFuel
                ? 'assets/images/tank_truck.gif'
                : 'assets/images/magnifying_glass.gif',
            nextRoute: isFuel ? Routes.serviceArrived : Routes.towingStarted,
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

  // ── Cancellation ────────────────────────────────────────────

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
      _cancel(context, orderId);
    }
  }

  void _cancel(BuildContext context, int orderId) {
    final bloc = sl<RequestBloc>()..add(CancelRequestEvent(orderId));
    bloc.stream.listen((state) {
      if (state is RequestCancelled) {
        widget.onCancelled?.call();
        if (context.mounted) {
          AppSnackbar.success(context, S.of(context).orderCancelledSuccess);
        }
      }
    });
  }
}

class _LiveDot extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  const _LiveDot({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        return SizedBox(
          width: 14.w,
          height: 14.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing halo
              Container(
                width: 14.w * (0.6 + 0.4 * t),
                height: 14.w * (0.6 + 0.4 * t),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.18 * (1 - t)),
                ),
              ),
              // Solid core
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Insets.s10,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.s8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: getSemiBoldStyle(color: color, fontSize: FontSize.s11),
      ),
    );
  }
}

class _StepInfo {
  final String label;
  final String subtitle;
  final double progress;
  final Color color;
  const _StepInfo({
    required this.label,
    required this.subtitle,
    required this.progress,
    required this.color,
  });
}
