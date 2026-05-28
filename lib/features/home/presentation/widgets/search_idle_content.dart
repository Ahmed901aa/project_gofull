import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'quick_shortcuts_row.dart';
import 'search_data.dart';
import 'search_result_tile.dart';

class SearchIdleContent extends StatelessWidget {
  final void Function(String route) onNavigate;
  const SearchIdleContent({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final items = getSearchableItems(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Insets.s24),
        Text(l10n.quickAccess, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        SizedBox(height: Insets.s12),
        QuickShortcutsRow(onNavigate: onNavigate),
        SizedBox(height: Insets.s24),
        Text(l10n.allServices, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        SizedBox(height: Insets.s12),
        ...items.map((item) => SearchResultTile(
              title: item['title'] as String, subtitle: item['subtitle'] as String,
              icon: item['icon'] as IconData, category: item['category'] as String,
              onTap: () => onNavigate(item['route'] as String),
            )),
      ],
    );
  }
}

class SearchEmptyResults extends StatelessWidget {
  const SearchEmptyResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 80.h),
        Icon(Icons.search_off_rounded, size: 48.sp, color: const Color(0xFFD9DADB)),
        SizedBox(height: Insets.s12),
        Center(child: Text(S.of(context).noResults, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16))),
        SizedBox(height: 4.h),
        Center(child: Text(S.of(context).tryDifferentSearch, style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14))),
      ],
    );
  }
}
