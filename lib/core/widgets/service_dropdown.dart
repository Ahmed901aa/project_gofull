import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Dropdown sibling of [ServiceInputField]. Same label / helper / focus /
/// error semantics so order forms (Tow Truck, Fuel) look consistent.
class ServiceDropdown extends StatelessWidget {
  final String? label;
  final String hint;
  final String? helper;
  final String? errorText;
  final IconData? prefixIcon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const ServiceDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.helper,
    this.errorText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final hasValue = value != null && value!.isNotEmpty;
    final borderColor = hasError
        ? context.colors.error
        : hasValue
            ? context.colors.primary.withValues(alpha: 0.6)
            : context.colors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: getSemiBoldStyle(
              color: context.colors.textPrimary,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.start,
          ),
          if (helper != null) ...[
            SizedBox(height: 2.h),
            Text(
              helper!,
              style: getRegularStyle(
                color: context.colors.textSecondary,
                fontSize: FontSize.s12,
              ),
            ),
          ],
          SizedBox(height: 6.h),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 52.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s14),
          decoration: BoxDecoration(
            color: context.colors.inputFill,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(
              color: borderColor,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  size: 18.sp,
                  color: hasError
                      ? context.colors.error
                      : hasValue
                          ? context.colors.primary
                          : context.colors.textSecondary,
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: value,
                    hint: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        hint,
                        style: getRegularStyle(
                          color: context.colors.textSecondary
                              .withValues(alpha: 0.65),
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.colors.textSecondary,
                      size: 22.sp,
                    ),
                    items: items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                item,
                                style: getMediumStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 13.sp, color: context.colors.error),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  errorText!,
                  style: getRegularStyle(
                    color: context.colors.error,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
