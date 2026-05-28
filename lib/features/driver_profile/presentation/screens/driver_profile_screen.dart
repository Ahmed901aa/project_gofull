import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';

import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/provider/domain/entities/provider_profile_entity.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_state.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProviderBloc>()..add(const LoadProfileEvent()),
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<ProviderBloc, ProviderState>(
                builder: (context, state) {
                  if (state is ProviderLoading) {
                    return Center(child: CircularProgressIndicator(color: context.colors.primary));
                  }
                  final profile = state is ProfileLoaded ? state.profile : null;
                  return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileCard(profile: profile),
                    SizedBox(height: Insets.s16),
                    _InfoBoxesRow(profile: profile),
                    SizedBox(height: Insets.s20),
                    _VehicleSection(profile: profile),
                    SizedBox(height: Insets.s24),
                  ],
                ),
              );
              },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
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
                        size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).profileTitle,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );
}

// ── Profile Card ─────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final ProviderProfileEntity? profile;
  const _ProfileCard({this.profile});
  @override
  Widget build(BuildContext context) {
    final name = profile?.userName ?? S.of(context).theDriver;
    final id = profile != null ? 'ID-${profile!.id}' : '';
    final role = profile?.isTowingProvider == true ? S.of(context).towDriverLabel : S.of(context).fuelSupplyDriver;
    final isOnline = profile?.isAvailable ?? false;
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s24),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: context.colors.goldLight,
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.surface, width: 2),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.person_rounded,
                size: 40.sp, color: context.colors.primary),
          ),
          SizedBox(width: Insets.s12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: getBoldStyle(
                      color: context.colors.surface, fontSize: FontSize.s18),
                ),
                SizedBox(height: 2.h),
                Text(
                  id,
                  style: getRegularStyle(
                      color: context.colors.surface.withValues(alpha: 0.7),
                      fontSize: FontSize.s12),
                ),
                SizedBox(height: 4.h),
                Text(
                  role,
                  style: getRegularStyle(
                      color: context.colors.surface, fontSize: FontSize.s14),
                ),
                SizedBox(height: Insets.s8),
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.s12, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: context.colors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  child: Text(
                    isOnline ? S.of(context).active : S.of(context).inactive,
                    style: getMediumStyle(
                        color: context.colors.gold, fontSize: FontSize.s12),
                  ),
                ),
              ],
            ),
          ),
          // Edit icon
          GestureDetector(
            onTap: () {
              // replace with navigation to edit profile
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: context.colors.surface.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child:
                  Icon(Icons.edit_rounded, size: 18.sp, color: context.colors.surface),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Boxes ───────────────────────────────────────────

class _InfoBoxesRow extends StatelessWidget {
  final ProviderProfileEntity? profile;
  const _InfoBoxesRow({this.profile});
  @override
  Widget build(BuildContext context) {
    final rating = profile?.averageRating.toStringAsFixed(1) ?? '-';
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _infoBox(context, S.of(context).rating, rating, Icons.star_rounded)),
            SizedBox(width: Insets.s12),
            Expanded(
                child: _infoBox(
                    context,
                    S.of(context).totalRatingsLabel, '${profile?.totalRatings ?? 0}', Icons.reviews_rounded)),
          ],
        ),
        SizedBox(height: Insets.s12),
        _infoBox(context, S.of(context).completedOrdersLabel, '${profile?.completedOrders ?? 0}', Icons.check_circle_rounded),
      ],
    );
  }

  Widget _infoBox(BuildContext context, String label, String value, IconData icon) => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.sp, color: context.colors.gold),
            SizedBox(height: Insets.s8),
            Text(
              value,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s18),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: getRegularStyle(
                  color: context.colors.iconSecondary, fontSize: FontSize.s12),
            ),
          ],
        ),
      );
}

// ── Vehicle Section ──────────────────────────────────────

class _VehicleSection extends StatelessWidget {
  final ProviderProfileEntity? profile;
  const _VehicleSection({this.profile});
  @override
  Widget build(BuildContext context) {
    final vehicleName = profile != null
        ? '${profile!.vehicleMake} ${profile!.vehicleModel}'
        : '—';
    final plate = profile?.vehiclePlate ?? '—';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.of(context).vehicleLabel2,
          style: getBoldStyle(
              color: context.colors.textPrimary, fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        Row(
          children: [
            Expanded(child: _vehicleBadge(context, S.of(context).vehicleTypeLabel, vehicleName)),
            SizedBox(width: Insets.s8),
            Expanded(child: _vehicleBadge(context, S.of(context).plateNumberVehicle, plate)),
          ],
        ),
        SizedBox(height: Insets.s12),
        // Vehicle image placeholder
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            color: context.colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_car_rounded,
                    size: 56.sp, color: context.colors.border),
                SizedBox(height: Insets.s8),
                Text(
                  S.of(context).vehicleImageLabel,
                  style: getRegularStyle(
                      color: context.colors.textSecondary, fontSize: FontSize.s14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _vehicleBadge(BuildContext context, String label, String value) => Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: getRegularStyle(
                  color: context.colors.iconSecondary, fontSize: FontSize.s12),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: getSemiBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s14),
            ),
          ],
        ),
      );
}
