import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class RatingNotesSection extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final VoidCallback onChanged;

  const RatingNotesSection({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.addNotes, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18), textAlign: TextAlign.start),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: 4,
            textAlign: TextAlign.start,
            style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
            decoration: InputDecoration(
              hintText: l10n.addNotesHint,
              hintStyle: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14),
              contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
        SizedBox(height: 4.h),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.s8),
            child: Text(
              '${controller.text.length}/$maxLength',
              style: getMediumStyle(color: context.colors.textSecondary, fontSize: FontSize.s14),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ],
    );
  }
}
