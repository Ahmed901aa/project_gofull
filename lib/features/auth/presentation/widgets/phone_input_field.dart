import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.inputBorder,
            ),
          ),
          child: Row(
            children: [
              // Country code section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Insets.s12,
                  vertical: Insets.s12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.inputBorder, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '218+',
                      style: getMediumStyle(
                        color: AppColors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text('🇱🇾', style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
              ),
              // Phone input
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.start,
                  style: getMediumStyle(
                    color: AppColors.black,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: S.of(context).phoneHint,
                    hintStyle: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: 16.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Insets.s12,
                      vertical: Insets.s12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsetsDirectional.only(top: 6.h, end: 4.w),
            child: Text(
              errorText!,
              style: getRegularStyle(
                color: AppColors.error,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
