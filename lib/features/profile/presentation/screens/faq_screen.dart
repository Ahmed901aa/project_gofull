import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/profile/presentation/widgets/faq_card.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

List<Map<String, String>> _getFaqs(S l10n) => [
  {'question': l10n.faqTripCost, 'answer': l10n.faqTripCostAnswer},
];

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final _faqs = _getFaqs(l10n);
    return Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s16),
                child: Column(
                  children: List.generate(_faqs.length, (i) => FaqCard(
                    question: _faqs[i]['question']!,
                    answer: _faqs[i]['answer']!,
                    isExpanded: _expandedIndex == i,
                    onTap: () => setState(() => _expandedIndex = _expandedIndex == i ? -1 : i),
                  )),
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
                  GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: context.colors.textPrimary)),
                  Expanded(child: Text(S.of(context).faq, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20), textAlign: TextAlign.center)),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );
}
