import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
          style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
          decoration: BoxDecoration(
            color: context.colors.primarySurface,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.primary),
          ),
          child: Text(
            l10n.ensureAtDestination,
            style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
