import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static List<_PolicySection> _getSections(S l10n) => [
    _PolicySection(title: l10n.privacyPolicyIntroTitle, body: l10n.privacyPolicyIntroBody),
    _PolicySection(title: l10n.privacyDataCollectedTitle, body: l10n.privacyDataCollectedBody),
    _PolicySection(title: l10n.privacyDataUseTitle, body: l10n.privacyDataUseBody),
    _PolicySection(title: l10n.privacyProtectionTitle, body: l10n.privacyProtectionBody),
    _PolicySection(title: l10n.privacyRightsTitle, body: l10n.privacyRightsBody),
    _PolicySection(title: l10n.privacyContactTitle, body: l10n.privacyContactBody),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final _sections = _getSections(l10n);
    return Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            AppHeader(title: l10n.privacyPolicy),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final section in _sections) ...[
                      Text(
                        section.title,
                        style: getBoldStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s18),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        section.body,
                        style: getRegularStyle(
                            color: context.colors.textSecondary,
                            fontSize: FontSize.s14),
                      ),
                      SizedBox(height: 20.h),
                    ],
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
  const _PolicySection({required this.title, required this.body});
}
