import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DiscountCodeInput extends StatelessWidget {
  final TextEditingController controller;
  const DiscountCodeInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.of(context).haveDiscountCode, style: getMediumStyle(color: const Color(0xFF121212), fontSize: FontSize.s16).copyWith(height: 1.4)),
        SizedBox(height: Sizes.s8),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          decoration: BoxDecoration(color: context.colors.inputFill, borderRadius: BorderRadius.circular(AppRadius.s16), border: Border.all(color: context.colors.border)),
          alignment: AlignmentDirectional.centerEnd,
          child: TextField(
            controller: controller,            decoration: InputDecoration(hintText: S.of(context).enterDiscountCode, hintStyle: getRegularStyle(color: context.colors.textDisabled, fontSize: FontSize.s14), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
            style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
          ),
        ),
        SizedBox(height: Insets.s16),
        SizedBox(
          height: 48.h, width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
            child: Text(S.of(context).activate, style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s16).copyWith(height: 1.6)),
          ),
        ),
      ],
    );
  }
}
