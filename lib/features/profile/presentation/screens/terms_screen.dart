import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import '../widgets/legal_hero_card.dart';
import '../widgets/legal_section_card.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static List<_TermSection> _getSections(S l10n) => [
        _TermSection(
            title: l10n.termsGeneralTitle,
            body: l10n.termsGeneralBody,
            icon: Icons.menu_book_rounded),
        _TermSection(
            title: l10n.termsOrdersTitle,
            body: l10n.termsOrdersBody,
            icon: Icons.receipt_long_rounded),
        _TermSection(
            title: l10n.termsDeliveryTitle,
            body: l10n.termsDeliveryBody,
            icon: Icons.local_shipping_outlined),
        _TermSection(
            title: l10n.termsWalletTitle,
            body: l10n.termsWalletBody,
            icon: Icons.account_balance_wallet_outlined),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final sections = _getSections(l10n);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          AppHeader(title: l10n.terms),
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
                    icon: Icons.description_outlined,
                    title: l10n.terms,
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

class _TermSection {
  final String title;
  final String body;
  final IconData icon;
  const _TermSection({
    required this.title,
    required this.body,
    required this.icon,
  });
}
