import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.location_on, color: context.colors.primary, size: 18.sp),
            SizedBox(width: Insets.s8),
            Expanded(child: isLoading
                ? Row(children: [
                    SizedBox(width: 14.w, height: 14.w,
                      child: CircularProgressIndicator(color: context.colors.primary, strokeWidth: 2)),
                    SizedBox(width: Insets.s8),
                    Text(S.of(context).loadingLocation,
                        style: getRegularStyle(color: context.colors.iconSecondary, fontSize: FontSize.s14)),
                  ])
                : Text(
                    address.isNotEmpty ? address : S.of(context).moveMapToSelectLocation,
                    style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
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
                backgroundColor: context.colors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
              ),
              child: Text(S.of(context).confirmLocation,
                  style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s16)),
            ),
          ),
        ],
      ),
    );
  }
}
