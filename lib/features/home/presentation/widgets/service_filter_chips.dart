import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ServiceFilterChips extends StatelessWidget {
  const ServiceFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final chips = [
      _ChipItem(
        label: l10n.petrol,
        icon: Icons.local_gas_station_rounded,
        onTap: () => Navigator.pushNamed(context, Routes.fuelType),
      ),
      _ChipItem(
        label: l10n.diesel,
        icon: Icons.local_gas_station_rounded,
        onTap: () => Navigator.pushNamed(context, Routes.fuelType),
      ),
      _ChipItem(
        label: l10n.chipTowPull,
        icon: Icons.fire_truck_rounded,
        onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
      ),
    ];

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: Insets.s8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return _Chip(chip: chip);
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final _ChipItem chip;
  const _Chip({required this.chip});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: chip.onTap,
        borderRadius: BorderRadius.circular(AppRadius.s24),
        splashColor: context.colors.primary.withValues(alpha: 0.10),
        highlightColor: context.colors.primary.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: Insets.s16,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: context.colors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.s24),
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.18),
              width: 1,
            ),
            boxShadow: context.isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DirectionalServiceIcon(
                chip.icon,
                size: 18.sp,
                color: context.colors.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                chip.label,
                style: getSemiBoldStyle(
                  color: context.colors.textPrimary,
                  fontSize: FontSize.s13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ChipItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
