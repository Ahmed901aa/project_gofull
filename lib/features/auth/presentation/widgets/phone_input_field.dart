import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Phone input field used on Login / Register.
///
/// Layout follows the active locale: in RTL the country-code chip sits on
/// the right (start), in LTR it sits on the left. The phone digits
/// themselves always render left-to-right (numbers convention), regardless
/// of the surrounding locale.
class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focused != _focusNode.hasFocus) {
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
    final hasError =
        widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError
        ? context.colors.error
        : _focused
            ? context.colors.primary
            : context.colors.inputBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.s12),
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
            children: [
              // ── Country-code chip ───────────────────────────────────
              // Sits on the START of the row (right in RTL, left in LTR).
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: Insets.s12,
                  vertical: Insets.s12,
                ),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    end: BorderSide(
                      color: context.colors.inputBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🇱🇾', style: TextStyle(fontSize: 20.sp)),
                    SizedBox(width: 6.w),
                    // Country code stays LTR so the "+" sits before the
                    // digits regardless of locale.
                    Text(
                      '+218',
                      textDirection: TextDirection.ltr,
                      style: getMediumStyle(
                        color: context.colors.textPrimary,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Phone icon ──────────────────────────────────────────
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: Insets.s10,
                ),
                child: Icon(
                  Icons.phone_iphone_rounded,
                  size: 18.sp,
                  color: hasError
                      ? context.colors.error
                      : _focused
                          ? context.colors.primary
                          : context.colors.textSecondary,
                ),
              ),

              // ── Number input ────────────────────────────────────────
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  // Digits always render LTR; the start alignment then
                  // pins them to the left of their slot, so the field
                  // looks correct in both RTL and LTR layouts.
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.start,
                  style: getMediumStyle(
                    color: context.colors.textPrimary,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: S.of(context).phoneHint,
                    // Placeholder is readable but clearly secondary:
                    // textSecondary at 65 % alpha gives a clean contrast
                    // against the entered (full-opacity) digits.
                    hintStyle: getRegularStyle(
                      color: context.colors.textSecondary
                          .withValues(alpha: 0.65),
                      fontSize: 16.sp,
                    ),
                    hintTextDirection: TextDirection.ltr,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsetsDirectional.symmetric(
                      horizontal: 0,
                      vertical: Insets.s12,
                    ),
                  ),
                ),
              ),
              SizedBox(width: Insets.s12),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsetsDirectional.only(top: 6.h, start: 4.w),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 13.sp,
                  color: context.colors.error,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: getRegularStyle(
                      color: context.colors.error,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
