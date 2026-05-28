import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ServiceDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const ServiceDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      decoration: BoxDecoration(
        color: context.colors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(hint, style: getRegularStyle(color: context.colors.textDisabled, fontSize: FontSize.s14)),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: context.colors.textSecondary, size: 20.sp),
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(item, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
            ),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
