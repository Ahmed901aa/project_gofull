import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class PickerConfirmCard extends StatelessWidget {
  final String address;
  final bool isLoading;
  final VoidCallback onConfirm;

  const PickerConfirmCard({
    super.key,
    required this.address,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s16, Insets.s16, 36.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.location_on, color: AppColors.primary, size: 18.sp),
            SizedBox(width: Insets.s8),
            Expanded(child: isLoading
                ? Row(children: [
                    SizedBox(width: 14.w, height: 14.w,
                      child: const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                    SizedBox(width: Insets.s8),
                    Text(S.of(context).loadingLocation,
                        style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
                  ])
                : Text(
                    address.isNotEmpty ? address : S.of(context).moveMapToSelectLocation,
                    style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  )),
          ]),
          SizedBox(height: Insets.s16),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
              ),
              child: Text(S.of(context).confirmLocation,
                  style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
            ),
          ),
        ],
      ),
    );
  }
}
