import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/home/presentation/widgets/search_data.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/features/home/presentation/widgets/search_header.dart';
import 'package:project_gofull/features/home/presentation/widgets/search_idle_content.dart';
import 'package:project_gofull/features/home/presentation/widgets/search_result_tile.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';

class AppSearchScreen extends StatefulWidget {
  const AppSearchScreen({super.key});
  @override
  State<AppSearchScreen> createState() => _AppSearchScreenState();
}

class _AppSearchScreenState extends State<AppSearchScreen> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearch);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) { setState(() => _results = []); return; }
    final items = getSearchableItems(context);
    final keywords = getSearchKeywords(context);
    setState(() {
      _results = items.where((item) {
        final title = item['title'] as String;
        final subtitle = item['subtitle'] as String;
        if (title.contains(query) || subtitle.contains(query)) return true;
        return (keywords[title] ?? []).any((k) => k.contains(query));
      }).toList().cast<Map<String, dynamic>>();
    });
  }

  void _navigate(String route) {
    if (route == '_orders') { Navigator.pop(context); BottomNavShell.shellKey.currentState?.switchTo(1); return; }
    if (route == '_support') { Navigator.pop(context); Navigator.pushNamed(context, Routes.support); return; }
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            SearchHeader(controller: _controller),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (query.isEmpty) SearchIdleContent(onNavigate: _navigate),
                    if (query.isNotEmpty && _results.isEmpty) const SearchEmptyResults(),
                    if (query.isNotEmpty && _results.isNotEmpty) ...[
                      SizedBox(height: Insets.s16),
                      Text('${S.of(context).searchResults} (${_results.length})', style: getMediumStyle(color: const Color(0xFF838485), fontSize: FontSize.s14)),
                      SizedBox(height: Insets.s12),
                      ..._results.map((item) => SearchResultTile(
                            title: item['title'] as String, subtitle: item['subtitle'] as String,
                            icon: item['icon'] as IconData, category: item['category'] as String,
                            highlightQuery: query, onTap: () => _navigate(item['route'] as String),
                          )),
                    ],
                    SizedBox(height: Insets.s16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
