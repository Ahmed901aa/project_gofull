import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

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
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        children: [
          _buildDriverInfo(),
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

  Widget _buildDriverInfo() => Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.neutral600),
              child: Icon(Icons.person_outline_rounded, size: 32.sp, color: const Color(0xFF0E0E0E)),
            ),
            SizedBox(width: Insets.s12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
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
    final l10n = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rating, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
          const SizedBox(width: 2),
          Icon(Icons.star_rounded, size: 14.sp, color: const Color(0xFFFFB800)),
          if (reviewCount.isNotEmpty) ...[
            const SizedBox(width: 2),
            Text('($reviewCount)', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
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
    final l10n = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBABABA).withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s12)),
          SizedBox(height: 2.h),
          Text(value, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        ],
      ),
    );
  }
}
