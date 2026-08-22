import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// One active order per customer, across BOTH service types.
///
/// Active statuses: pending, accepted, en_route, arrived, in_progress.
/// A new order is allowed again once the current one is completed or
/// cancelled. The backend is the final authority (ACTIVE_ORDER_EXISTS,
/// race-safe); this dialog is the single UX for both the client-side
/// pre-check and the server rejection.
Future<void> showActiveOrderDialog(BuildContext context) async {
  // Refresh home data so a stale "active" order (e.g. completed while the
  // user sat on this screen) clears itself for the next attempt.
  context.read<AppConfigBloc>().add(const LoadHomeDataEvent());

  final l10n = S.of(context);
  final viewOrder = await AppConfirmDialog.show(
    context,
    icon: Icons.assignment_rounded,
    iconColor: context.colors.info,
    title: l10n.activeOrderTitle,
    subtitle: l10n.activeOrderWarning,
    confirmLabel: l10n.viewCurrentOrder,
    cancelLabel: l10n.notNowBtn,
  );
  if (viewOrder && context.mounted) {
    // Home shows the live active-order card/banner with its "continue"
    // action — the single existing entry point for tracking.
    BottomNavShell.popToHome(context);
  }
}
