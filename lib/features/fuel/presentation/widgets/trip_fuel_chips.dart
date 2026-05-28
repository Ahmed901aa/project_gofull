import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class TripFuelChips extends StatelessWidget {
  final String fuelType;
  final String quantity;

  const TripFuelChips({
    super.key,
    this.fuelType = '—',
    this.quantity = '—',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _Chip(label: l10n.fuelType, value: fuelType)),
          SizedBox(width: Insets.s16),
          Expanded(child: _Chip(label: l10n.requestedQuantity, value: quantity)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  const _Chip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.textDisabled.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12)),
          SizedBox(height: 2.h),
          Text(value, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
        ],
      ),
    );
  }
}
