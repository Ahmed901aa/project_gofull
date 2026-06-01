import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import '../widgets/legal_hero_card.dart';
import '../widgets/legal_section_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static List<_PolicySection> _getSections(S l10n) => [
        _PolicySection(
            title: l10n.privacyPolicyIntroTitle,
            body: l10n.privacyPolicyIntroBody,
            icon: Icons.info_outline_rounded),
        _PolicySection(
            title: l10n.privacyDataCollectedTitle,
            body: l10n.privacyDataCollectedBody,
            icon: Icons.folder_open_rounded),
        _PolicySection(
            title: l10n.privacyDataUseTitle,
            body: l10n.privacyDataUseBody,
            icon: Icons.bolt_rounded),
        _PolicySection(
            title: l10n.privacyProtectionTitle,
            body: l10n.privacyProtectionBody,
            icon: Icons.lock_outline_rounded),
        _PolicySection(
            title: l10n.privacyRightsTitle,
            body: l10n.privacyRightsBody,
            icon: Icons.gavel_rounded),
        _PolicySection(
            title: l10n.privacyContactTitle,
            body: l10n.privacyContactBody,
            icon: Icons.support_agent_rounded),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final sections = _getSections(l10n);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          AppHeader(title: l10n.privacyPolicy),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.fromSTEB(
                Insets.s16,
                Insets.s16,
                Insets.s16,
                Insets.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LegalHeroCard(
                    icon: Icons.shield_outlined,
                    title: l10n.privacyPolicyAppTitle,
                    lastUpdated: l10n.privacyPolicyLastUpdate,
                  ),
                  SizedBox(height: Sizes.s20),
                  for (var i = 0; i < sections.length; i++) ...[
                    LegalSectionCard(
                      number: i + 1,
                      icon: sections[i].icon,
                      title: sections[i].title,
                      body: sections[i].body,
                    ),
                    if (i < sections.length - 1) SizedBox(height: Sizes.s12),
                  ],
                  SizedBox(height: Sizes.s20),
                  Text(
                    l10n.privacyPolicyFooter,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      color: context.colors.textSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final String title;
  final String body;
  final IconData icon;
  const _PolicySection({
    required this.title,
    required this.body,
    required this.icon,
  });
}
