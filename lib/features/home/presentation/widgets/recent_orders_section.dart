import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequestBloc>()..add(const LoadRequestsEvent()),
      child: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          if (state is! RequestsLoaded || state.requests.isEmpty) {
            return const SizedBox.shrink();
          }
          // Show last 2 orders
          final orders = state.requests.take(2).toList();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(S.of(context).recentOrders,
                        style: getSemiBoldStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s18)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Switch to orders tab
                        BottomNavShell.shellKey.currentState?.switchTo(1);
                      },
                      child: Text(S.of(context).viewAll,
                          style: getMediumStyle(
                              color: context.colors.primary,
                              fontSize: FontSize.s14)),
                    ),
                  ],
                ),
                SizedBox(height: Sizes.s12),
                ...orders.map((order) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _RecentOrderCard(order: order),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RecentOrderCard extends StatelessWidget {
  final ServiceRequestEntity order;
  const _RecentOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;
    final isTow = order.isTowing;
    final price =
        order.total != null ? '${order.total} $cur' : '—';
    final date = order.createdAt?.substring(0, 10) ?? '';

    String statusLabel;
    Color statusColor;
    if (order.isCompleted) {
      statusLabel = l10n.completed;
      statusColor = context.colors.success;
    } else if (order.isCancelled) {
      statusLabel = l10n.cancelled;
      statusColor = context.colors.error;
    } else {
      statusLabel = l10n.inProgress;
      statusColor = context.colors.primary;
    }

    return Container(
      padding: EdgeInsets.all(Insets.s12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Service type
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isTow
                        ? Icons.fire_truck_rounded
                        : Icons.local_gas_station_rounded,
                    size: 16.sp,
                    color: context.colors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    isTow ? l10n.towService : l10n.fuelSupply,
                    style: getMediumStyle(
                        color: context.colors.textPrimary,
                        fontSize: FontSize.s14),
                  ),
                ],
              ),
              const Spacer(),
              // Status
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8, vertical: 2.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Text(statusLabel,
                    style: getMediumStyle(
                        color: statusColor, fontSize: FontSize.s12)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(date,
                  style: getRegularStyle(
                      color: context.colors.iconSecondary, fontSize: FontSize.s12)),
              const Spacer(),
              Text(price,
                  style: getSemiBoldStyle(
                      color: context.colors.textPrimary,
                      fontSize: FontSize.s14)),
            ],
          ),
        ],
      ),
    );
  }
}
