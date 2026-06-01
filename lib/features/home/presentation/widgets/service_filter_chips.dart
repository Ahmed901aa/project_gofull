import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
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
        label: l10n.towService,
        icon: Icons.fire_truck_rounded,
        onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
      ),
    ];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: Insets.s8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return GestureDetector(
            onTap: chip.onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.s16,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: context.colors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.s24),
                border: Border.all(
                  color: context.colors.borderSubtle,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(chip.icon, size: 18.sp, color: context.colors.primary),
                  SizedBox(width: 6.w),
                  Text(
                    chip.label,
                    style: getMediumStyle(
                      color: context.colors.textPrimary,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
