import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
    this.vehicleLabel = 'نوع الساحبة',
    this.vehicleValue = '—',
    this.plateNumber = '—',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F4),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
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
                  decoration: const BoxDecoration(
                      color: AppColors.white, shape: BoxShape.circle),
                  child: Icon(Icons.person_rounded,
                      color: AppColors.neutral800, size: 32.sp),
                ),
                SizedBox(width: Insets.s12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driverName,
                        style: getBoldStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s16)),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s8, vertical: 4.h),
                      decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius:
                              BorderRadius.circular(AppRadius.s16),
                          border:
                              Border.all(color: const Color(0xFFEFF0F1))),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                color: const Color(0xFFFFB800),
                                size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(ratingValue,
                                style: getBoldStyle(
                                    color: const Color(0xFF0E0E0E),
                                    fontSize: FontSize.s14)),
                            if (reviewCount.isNotEmpty) ...[
                              SizedBox(width: 2.w),
                              Text('($reviewCount)',
                                  style: getRegularStyle(
                                      color: AppColors.neutral900,
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
                _infoPill(label: vehicleLabel, value: vehicleValue),
                SizedBox(width: Insets.s16),
                _infoPill(label: 'رقم اللوحة', value: plateNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPill({required String label, required String value}) => Expanded(
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: 4.h, horizontal: Insets.s16),
          decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: const Color(0xFFEFF0F1))),
          child: Column(children: [
            Text(label,
                style: getRegularStyle(
                    color: AppColors.neutral900, fontSize: FontSize.s12)),
            SizedBox(height: 2.h),
            Text(value,
                style: getBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s14)),
          ]),
        ),
      );
}
