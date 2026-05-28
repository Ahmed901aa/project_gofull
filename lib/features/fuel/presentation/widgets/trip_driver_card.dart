import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class TripDriverCard extends StatelessWidget {
  final String name;
  final String rating;
  final String reviewCount;
  final String plateNumber;
  final String vehicleType;

  const TripDriverCard({
    super.key,
    this.name = '—',
    this.rating = '—',
    this.reviewCount = '',
    this.plateNumber = '—',
    this.vehicleType = '—',
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
      child: Column(
        children: [
          _buildDriverInfo(context),
          SizedBox(height: Insets.s12),
          Row(
            children: [
              Expanded(child: _InfoChip(label: l10n.plateNumber, value: plateNumber)),
              SizedBox(width: Insets.s16),
              Expanded(child: _InfoChip(label: l10n.vehicleTypeLabel, value: vehicleType)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo(BuildContext context) => Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.colors.border),
              child: Icon(Icons.person_outline_rounded, size: 32.sp, color: context.colors.textPrimary),
            ),
            SizedBox(width: Insets.s12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
                SizedBox(height: 2.h),
                _RatingBadge(rating: rating, reviewCount: reviewCount),
              ],
            ),
          ],
      );
}

class _RatingBadge extends StatelessWidget {
  final String rating;
  final String reviewCount;
  const _RatingBadge({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rating, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
          const SizedBox(width: 2),
          Icon(Icons.star_rounded, size: 14.sp, color: context.colors.gold),
          if (reviewCount.isNotEmpty) ...[
            const SizedBox(width: 2),
            Text('($reviewCount)', style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14)),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
