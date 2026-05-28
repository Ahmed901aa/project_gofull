import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class SupportPhoneCard extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onTap;

  const SupportPhoneCard({
    super.key,
    required this.phoneNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: const Color(0xFFEFF0F1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_rounded,
                size: 22.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).directCall,
                    style: getBoldStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: FontSize.s16,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\${S.of(context).mobileNumber} $phoneNumber',
                    style: getRegularStyle(
                      color: const Color(0xFF646565),
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
