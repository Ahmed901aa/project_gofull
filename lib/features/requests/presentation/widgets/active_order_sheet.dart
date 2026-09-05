import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Guards against a second sheet stacking on the first — a fast double tap
/// on "confirm order", or the client pre-check and the server rejection
/// both firing for the same attempt. Always cleared in a `finally`, so a
/// dismissed sheet can be reopened.
bool _sheetOpen = false;

/// Clears the guard between widget tests, where a test can end with the
/// sheet still open (its future never resolves, so `finally` never runs).
@visibleForTesting
void debugResetActiveOrderSheetGuard() => _sheetOpen = false;

/// One active order per customer, across BOTH service types.
///
/// Active statuses: pending, accepted, en_route, arrived, in_progress.
/// A new order is allowed again once the current one is completed or
/// cancelled. The backend is the final authority (ACTIVE_ORDER_EXISTS,
/// race-safe); this sheet is the single UX for both the client-side
/// pre-check and the server rejection.
Future<void> showActiveOrderSheet(BuildContext context) async {
  if (_sheetOpen) return;
  _sheetOpen = true;

  // Refresh home data so a stale "active" order (e.g. one completed while
  // the user sat on this screen) resolves itself — the sheet listens and
  // closes on its own if the order is no longer active.
  context.read<AppConfigBloc>().add(const LoadHomeDataEvent());

  try {
    final viewOrder = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => const _ActiveOrderSheet(),
    );

    if (viewOrder == true && context.mounted) {
      // Home carries the live active-order card with its "continue"
      // action — the one existing entry point into tracking.
      BottomNavShell.popToHome(context);
    }
  } finally {
    _sheetOpen = false;
  }
}

class _ActiveOrderSheet extends StatelessWidget {
  const _ActiveOrderSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = S.of(context);

    return BlocConsumer<AppConfigBloc, AppConfigState>(
      // If the current order finishes while this sheet is open, the
      // restriction no longer applies — get out of the user's way.
      listenWhen: (prev, curr) =>
          prev.activeOrder != null && curr.activeOrder == null,
      listener: (context, _) => Navigator.of(context).maybePop(false),
      builder: (context, state) {
        final order = state.activeOrder;
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    Insets.s20, Insets.s12, Insets.s20, Insets.s20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _DragHandle(),
                    SizedBox(height: Sizes.s24),
                    _ServiceBadge(order: order),
                    SizedBox(height: Sizes.s16),
                    Text(
                      l10n.activeOrderTitle,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                          color: colors.textPrimary, fontSize: FontSize.s18),
                    ),
                    SizedBox(height: Sizes.s8),
                    Text(
                      l10n.activeOrderSheetBody,
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                          color: colors.textSecondary, fontSize: FontSize.s14),
                    ),
                    if (order != null) ...[
                      SizedBox(height: Sizes.s20),
                      _OrderSummaryCard(order: order),
                    ],
                    SizedBox(height: Sizes.s24),
                    AppButton(
                      text: l10n.viewCurrentOrder,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                    SizedBox(height: Sizes.s8),
                    // 48dp min touch target, matching the primary button.
                    SizedBox(
                      height: Sizes.s48,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.s12),
                          ),
                        ),
                        child: Text(
                          l10n.closeBtn,
                          style: getMediumStyle(
                              color: colors.textSecondary,
                              fontSize: FontSize.s14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: context.colors.border,
            borderRadius: BorderRadius.circular(AppRadius.s8),
          ),
        ),
      );
}

/// Service illustration in a tinted circle, with a soft entrance so the
/// sheet feels considered rather than abrupt. Uses the app's own icons —
/// the tow-truck artwork for towing, the fuel glyph for fuel delivery.
class _ServiceBadge extends StatelessWidget {
  final ServiceRequestEntity? order;
  const _ServiceBadge({required this.order});

  @override
  Widget build(BuildContext context) {
    final isTowing = order?.isTowing ?? false;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.85, end: 1),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: scale.clamp(0.0, 1.0),
            child: child,
          ),
        ),
        child: Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.primarySurface,
          ),
          alignment: Alignment.center,
          child: isTowing
              ? TowTruckIcon(size: 40.w)
              : Icon(Icons.local_gas_station_rounded,
                  size: 34.sp, color: context.colors.primary),
        ),
      ),
    );
  }
}

/// Compact summary of the order that is blocking a new one: what it is,
/// where it has got to, its number, and who is handling it.
class _OrderSummaryCard extends StatelessWidget {
  final ServiceRequestEntity order;
  const _OrderSummaryCard({required this.order});

  String _statusLabel(BuildContext context) {
    final l10n = S.of(context);
    switch (order.status) {
      case 'pending':
        return l10n.pendingAcceptance;
      case 'accepted':
        return l10n.orderAccepted;
      case 'en_route':
        return l10n.enRoute;
      case 'arrived':
        return l10n.arrived;
      case 'in_progress':
        return l10n.inProgress;
      default:
        return l10n.processing;
    }
  }

  String? _providerName() {
    final user = order.providerInfo?['user'] as Map<String, dynamic>?;
    final name = user?['name'] as String?;
    return (name != null && name.isNotEmpty) ? name : null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = S.of(context);
    final provider = _providerName();

    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.isTowing ? l10n.towingService : l10n.fuelService,
                  style: getBoldStyle(
                      color: colors.textPrimary, fontSize: FontSize.s16),
                ),
              ),
              SizedBox(width: Insets.s8),
              _StatusChip(label: _statusLabel(context)),
            ],
          ),
          SizedBox(height: Sizes.s12),
          _SummaryRow(
            icon: Icons.tag_rounded,
            label: l10n.orderNumberLabel,
            // Digits stay LTR so the number never reorders in Arabic.
            value: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '#${order.id}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                    color: colors.textPrimary, fontSize: FontSize.s14),
              ),
            ),
          ),
          if (provider != null) ...[
            SizedBox(height: Sizes.s8),
            _SummaryRow(
              icon: Icons.person_outline_rounded,
              label: l10n.providerDetails,
              value: Text(
                provider,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: getMediumStyle(
                    color: colors.textPrimary, fontSize: FontSize.s14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsetsDirectional.symmetric(
            horizontal: Insets.s12, vertical: 4.h),
        decoration: BoxDecoration(
          color: context.colors.primarySurface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        child: Text(
          label,
          style: getMediumStyle(
              color: context.colors.primary, fontSize: FontSize.s12),
        ),
      );
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget value;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 16.sp, color: context.colors.iconSecondary),
          SizedBox(width: Insets.s8),
          // Both sides flex, so neither a long localized label nor a long
          // provider name can push the row past its width.
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getRegularStyle(
                  color: context.colors.textSecondary, fontSize: FontSize.s14),
            ),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: value,
            ),
          ),
        ],
      );
}
