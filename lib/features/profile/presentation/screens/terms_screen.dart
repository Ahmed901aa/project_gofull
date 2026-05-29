import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

List<Map<String, String>> _getTermsSections(S l10n) => [
  {'title': l10n.termsGeneralTitle, 'body': l10n.termsGeneralBody},
  {'title': l10n.termsOrdersTitle, 'body': l10n.termsOrdersBody},
  {'title': l10n.termsDeliveryTitle, 'body': l10n.termsDeliveryBody},
  {'title': l10n.termsWalletTitle, 'body': l10n.termsWalletBody},
];

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final sections = _getTermsSections(l10n);
    return Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: sections.map((s) => Padding(
                    padding: EdgeInsets.only(bottom: Insets.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s['title']!,
                          style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16),
                        ),
                        SizedBox(height: Insets.s8),
                        Text(
                          s['body']!,
                          style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s14).copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(backArrowIcon(context), size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).terms,
                      style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );
}
