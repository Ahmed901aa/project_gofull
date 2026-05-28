import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverCard extends StatelessWidget {
  final String driverName;
  final String ratingValue;
  final String reviewCount;
  final String vehicleLabel;
  final String vehicleValue;
  final String plateNumber;

  const DriverCard({
    super.key,
    this.driverName = '—',
    this.ratingValue = '—',
    this.reviewCount = '',
    this.vehicleLabel = '',
    this.vehicleValue = '—',
    this.plateNumber = '—',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: avatar + name + rating
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                Insets.s16, Insets.s12, Insets.s16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                      color: context.colors.surface, shape: BoxShape.circle),
                  child: Icon(Icons.person_rounded,
                      color: context.colors.textSecondary, size: 32.sp),
                ),
                SizedBox(width: Insets.s12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driverName,
                        style: getBoldStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s16)),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s8, vertical: 4.h),
                      decoration: BoxDecoration(
                          color: context.colors.inputFill,
                          borderRadius:
                              BorderRadius.circular(AppRadius.s16),
                          border:
                              Border.all(color: context.colors.border)),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                color: context.colors.gold,
                                size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(ratingValue,
                                style: getBoldStyle(
                                    color: context.colors.textPrimary,
                                    fontSize: FontSize.s14)),
                            if (reviewCount.isNotEmpty) ...[
                              SizedBox(width: 2.w),
                              Text('($reviewCount)',
                                  style: getRegularStyle(
                                      color: context.colors.textSecondary,
                                      fontSize: FontSize.s14)),
                            ],
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          // Row 2: info pills
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                Insets.s16, 0, Insets.s16, Insets.s12),
            child: Row(
              children: [
                _infoPill(context, label: vehicleLabel, value: vehicleValue),
                SizedBox(width: Insets.s16),
                _infoPill(context, label: S.of(context).plateNumber, value: plateNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPill(BuildContext context, {required String label, required String value}) => Expanded(
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: 4.h, horizontal: Insets.s16),
          decoration: BoxDecoration(
              color: context.colors.inputFill,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: context.colors.border)),
          child: Column(children: [
            Text(label,
                style: getRegularStyle(
                    color: context.colors.textSecondary, fontSize: FontSize.s12)),
            SizedBox(height: 2.h),
            Text(value,
                style: getBoldStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s14)),
          ]),
        ),
      );
}
