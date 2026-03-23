import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
        color: const Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Align(
            alignment: Alignment.centerRight,
            child: Text(hint, style: getRegularStyle(color: const Color(0xFFAAAAAB), fontSize: FontSize.s14)),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.neutral900, size: 20.sp),
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(item, style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
            ),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
