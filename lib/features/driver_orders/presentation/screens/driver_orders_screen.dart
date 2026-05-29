import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_state.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class DriverOrdersScreen extends StatelessWidget {
  const DriverOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProviderBloc>()..add(const LoadHistoryEvent()),
      child: Scaffold(
          backgroundColor: context.colors.background,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<ProviderBloc, ProviderState>(
                  builder: (context, state) {
                    if (state is ProviderLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: context.colors.primary));
                    }
                    if (state is ProviderError) {
                      return Center(
                          child: Text(state.message,
                              style: getRegularStyle(
                                  color: context.colors.iconSecondary,
                                  fontSize: FontSize.s16)));
                    }
                    if (state is HistoryLoaded) {
                      return _buildList(context, state.requests);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildList(
      BuildContext context, List<ServiceRequestEntity> requests) {
    if (requests.isEmpty) {
      return Center(
          child: Text(S.of(context).noRecentOrders,
              style: getRegularStyle(
                  color: context.colors.iconSecondary, fontSize: FontSize.s16)));
    }
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(Insets.s16),
      itemCount: requests.length,
      separatorBuilder: (_, __) =>
          Divider(color: context.colors.divider, height: 1),
      itemBuilder: (context, index) =>
          _OrderCard(request: requests[index], currency: cur),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(children: [
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(backArrowIcon(context),
                      size: 24.sp, color: context.colors.textPrimary)),
              Expanded(
                  child: Text(S.of(context).recentOrdersTitle,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center)),
              SizedBox(width: 24.sp),
            ]),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ]),
      );
}

class _OrderCard extends StatelessWidget {
  final ServiceRequestEntity request;
  final String currency;
  const _OrderCard({required this.request, required this.currency});

  @override
  Widget build(BuildContext context) {
    final isTow = request.isTowing;
    final address = request.driverAddress ?? '';
    final total = request.total != null
        ? '${request.total} $currency'
        : '—';
    final date = request.createdAt ?? '';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.driverTripDetails,
        arguments: DriverTripDetailsArgs(
          orderId: request.id.toString(),
          serviceType: isTow ? 'tow' : 'fuel',
          isRated: request.isRated,
        ),
      ),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              _ServiceBadge(isTow: isTow),
            ]),
            SizedBox(height: Insets.s12),
            Row(children: [
              Icon(Icons.location_on_outlined,
                  size: 18.sp, color: context.colors.iconSecondary),
              SizedBox(width: 4.w),
              Expanded(
                  child: Text(address,
                      style: getRegularStyle(
                          color: context.colors.textSecondary, fontSize: FontSize.s14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ]),
            SizedBox(height: Insets.s8),
            Row(children: [
              Icon(Icons.access_time_rounded,
                  size: 16.sp, color: context.colors.iconSecondary),
              SizedBox(width: 4.w),
              Text(date,
                  style: getRegularStyle(
                      color: context.colors.iconSecondary, fontSize: FontSize.s12)),
            ]),
            SizedBox(height: Insets.s12),
            Row(children: [
              Text(S.of(context).totalLabel,
                  style: getRegularStyle(
                      color: context.colors.iconSecondary, fontSize: FontSize.s14)),
              SizedBox(width: 4.w),
              Text(total,
                  style: getBoldStyle(
                      color: context.colors.textPrimary,
                      fontSize: FontSize.s16)),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8, vertical: 4.h),
                decoration: BoxDecoration(
                    color: context.colors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.s16)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle_rounded,
                      size: 14.sp, color: context.colors.primary),
                  SizedBox(width: 4.w),
                  Text(S.of(context).cashLabel,
                      style: getMediumStyle(
                          color: context.colors.primary, fontSize: FontSize.s12)),
                ]),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ServiceBadge extends StatelessWidget {
  final bool isTow;
  const _ServiceBadge({required this.isTow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
          color: isTow
              ? context.colors.primary.withValues(alpha: 0.1)
              : context.colors.gold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.s8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
            isTow ? Icons.fire_truck_rounded : Icons.local_gas_station_rounded,
            size: 14.sp,
            color: isTow ? context.colors.primary : context.colors.gold),
        SizedBox(width: 4.w),
        Text(isTow ? S.of(context).towService : S.of(context).fuelService,
            style: getMediumStyle(
                color: isTow ? context.colors.primary : context.colors.gold,
                fontSize: FontSize.s12)),
      ]),
    );
  }
}

