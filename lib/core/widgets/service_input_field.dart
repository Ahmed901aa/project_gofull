import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Reusable input field used by order forms (Tow Truck, Fuel, etc.).
///
/// Features:
/// - Optional [label] rendered above the field.
/// - Optional [helper] line under the label (e.g. "Example: …").
/// - Optional [prefixIcon] inside the field for context.
/// - Optional [errorText] that paints a red border + message under the field.
/// - Visible focus state (border tint + soft brand glow).
/// - Placeholder uses `textSecondary` for proper contrast (the old version
///   used `textDisabled` and looked faint).
class ServiceInputField extends StatefulWidget {
  final String? label;
  final String hint;
  final String? helper;
  final String? errorText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final int? maxLength;

  const ServiceInputField({
    super.key,
    required this.hint,
    this.label,
    this.helper,
    this.errorText,
    this.controller,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<ServiceInputField> createState() => _ServiceInputFieldState();
}

class _ServiceInputFieldState extends State<ServiceInputField> {
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError
        ? context.colors.error
        : _focused
            ? context.colors.primary
            : context.colors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: getSemiBoldStyle(
              color: context.colors.textPrimary,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.start,
          ),
          if (widget.helper != null) ...[
            SizedBox(height: 2.h),
            Text(
              widget.helper!,
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
          padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s14),
          decoration: BoxDecoration(
            color: context.colors.inputFill,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(
              color: borderColor,
              width: _focused || hasError ? 1.5 : 1,
            ),
            boxShadow: _focused && !hasError
                ? [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null) ...[
                Icon(
                  widget.prefixIcon,
                  size: 18.sp,
                  color: hasError
                      ? context.colors.error
                      : _focused
                          ? context.colors.primary
                          : context.colors.textSecondary,
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  textAlign: TextAlign.start,
                  style: getRegularStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s14,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: getRegularStyle(
                      color: context.colors.textSecondary
                          .withValues(alpha: 0.65),
                      fontSize: FontSize.s14,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    counterText: '',
                    contentPadding:
                        EdgeInsetsDirectional.symmetric(vertical: 12.h),
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
                  widget.errorText!,
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
