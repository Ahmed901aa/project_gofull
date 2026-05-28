import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'bullet_item.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class FuelCompleteSafetySection extends StatefulWidget {
  final List<String> items;
  const FuelCompleteSafetySection({super.key, required this.items});

  @override
  State<FuelCompleteSafetySection> createState() => _FuelCompleteSafetySectionState();
}

class _FuelCompleteSafetySectionState extends State<FuelCompleteSafetySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.safetyGuidelines, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18), textAlign: TextAlign.start),
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
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.items.map((t) => BulletItem(text: t, last: t == widget.items.last)).toList(),
                      )
                    : BulletItem(text: widget.items.first, last: true),
              ),
              SizedBox(height: Insets.s8),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? l10n.hideAll : l10n.viewAll,
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
