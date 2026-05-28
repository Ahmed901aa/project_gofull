import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class TripSafetySection extends StatelessWidget {
  const TripSafetySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.safetyGuidelines,
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.primary),
          ),
          child: Text(
            l10n.ensureAtDestination,
            style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
