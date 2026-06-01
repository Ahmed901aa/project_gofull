import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class TripRouteCard extends StatelessWidget {
  final String title;
  final String address;
  final String? distanceLabel;
  final String? distanceValue;

  const TripRouteCard({
    super.key,
    required this.title,
    required this.address,
    this.distanceLabel,
    this.distanceValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.border,
              ),
              child: Icon(Icons.location_on_outlined, size: 32.sp, color: context.colors.textPrimary),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
                  SizedBox(height: 2.h),
                  Text(address, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14)),
                  if (distanceLabel != null && distanceValue != null) ...[
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '$distanceLabel ',
                          style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
                        ),
                        TextSpan(
                          text: distanceValue,
                          style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
                        ),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
  }
}
