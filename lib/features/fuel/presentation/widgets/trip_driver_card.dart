import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

// replace with API data later
const _name = 'محمود عبدالعليم';
const _rating = '4.9';
const _reviews = '541';
const _plate = 'أ ب م - 3541';
const _vehicle = 'ونش هيدروليك';

class TripDriverCard extends StatelessWidget {
  const TripDriverCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              Expanded(child: _InfoChip(label: 'رقم اللوحة', value: _plate)),
              SizedBox(width: Insets.s16),
              Expanded(child: _InfoChip(label: 'نوع الونش', value: _vehicle)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() => Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
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
                Text(_name, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
                SizedBox(height: 2.h),
                _RatingBadge(),
              ],
            ),
          ],
        ),
      );
}

class _RatingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Text(_rating, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
          const SizedBox(width: 2),
          Icon(Icons.star_rounded, size: 14.sp, color: const Color(0xFFFFB800)),
          const SizedBox(width: 2),
          Text('($_reviews)', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
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
