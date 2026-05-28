import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class TripLocationCard extends StatelessWidget {
  final String address;

  const TripLocationCard({super.key, this.address = '—'});

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
      child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neutral600,
              ),
              child: Icon(Icons.location_on_outlined, size: 32.sp, color: const Color(0xFF0E0E0E)),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.carLocationLabel, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
                  SizedBox(height: 2.h),
                  Text(address, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
