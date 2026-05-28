import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ArrivedSafetyCard extends StatefulWidget {
  const ArrivedSafetyCard({super.key});

  @override
  State<ArrivedSafetyCard> createState() => _ArrivedSafetyCardState();
}

class _ArrivedSafetyCardState extends State<ArrivedSafetyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final safetyItems = [
      l10n.safetyCheckCarCondition,
      l10n.safetyCheckLocation,
      l10n.safetyCollectBelongings,
      l10n.safetyDropOffArea,
      l10n.safetyFinancialTransaction,
    ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_expanded)
                Text(
                  l10n.ensureAtDestination,
                  style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s14),
                  textAlign: TextAlign.start,
                ),
              if (_expanded)
                for (final item in safetyItems) ...[
                  Text(item, style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s14), textAlign: TextAlign.start),
                  SizedBox(height: Insets.s12),
                ],
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? l10n.hideDisplay : l10n.showAll,
                  style: getBoldStyle(color: context.colors.primary, fontSize: FontSize.s14),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
