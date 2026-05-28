import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class SafetyNoticeCard extends StatelessWidget {
  const SafetyNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE1E3),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFE63946)),
      ),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          children: [
            TextSpan(
              text: l10n.safetyFirstTitle,
              style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            ),
            TextSpan(
              text: l10n.safetyFirstBody,
              style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }
}
