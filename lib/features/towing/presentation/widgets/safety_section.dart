import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class SafetySection extends StatelessWidget {
  final List<String>? items;
  const SafetySection({super.key, this.items});

  static List<String> _defaultItems(S l10n) => [
    l10n.safetySecureCar,
    l10n.safetyTurnOffEngine,
    l10n.safetyConfirmType,
    l10n.safetyNoSmoking,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final displayItems = items ?? _defaultItems(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.safetyGuidelines, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: displayItems.map((t) => _BulletItem(text: t, last: t == displayItems.last)).toList(),
          ),
        ),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final bool last;
  const _BulletItem({required this.text, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 6.w),
            child: Container(
              width: 5.w, height: 5.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Text(text, style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
