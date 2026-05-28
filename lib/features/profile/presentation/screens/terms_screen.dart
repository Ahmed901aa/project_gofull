import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

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
    final _sections = _getTermsSections(l10n);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _sections.map((s) => Padding(
                    padding: EdgeInsets.only(bottom: Insets.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s['title']!,
                          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                        ),
                        SizedBox(height: Insets.s8),
                        Text(
                          s['body']!,
                          style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      l10n.terms,
                      style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );
}
