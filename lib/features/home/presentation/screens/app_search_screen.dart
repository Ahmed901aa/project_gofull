import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/home/presentation/widgets/quick_shortcuts_row.dart';
import 'package:project_gofull/features/home/presentation/widgets/search_data.dart';
import 'package:project_gofull/features/home/presentation/widgets/search_header.dart';
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _results = searchableItems.where((item) {
        final title = item['title'] as String;
        final subtitle = item['subtitle'] as String;
        if (title.contains(query) || subtitle.contains(query)) return true;
        final keywords = searchKeywords[title] ?? [];
        return keywords.any((k) => k.contains(query));
      }).toList().cast<Map<String, dynamic>>();
    });
  }

  void _navigate(String route) {
    if (route == '_orders') {
      Navigator.pop(context);
      BottomNavShell.shellKey.currentState?.switchTo(1);
      return;
    }
    if (route == '_support') {
      Navigator.pop(context);
      Navigator.pushNamed(context, Routes.support);
      return;
    }
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                    if (query.isEmpty) ..._buildIdleContent(),
                    if (query.isNotEmpty && _results.isEmpty) ..._buildEmptyResults(),
                    if (query.isNotEmpty && _results.isNotEmpty) ..._buildResults(query),
                    SizedBox(height: Insets.s16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIdleContent() => [
        SizedBox(height: Insets.s24),
        Text('الوصول السريع', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        SizedBox(height: Insets.s12),
        QuickShortcutsRow(onNavigate: _navigate),
        SizedBox(height: Insets.s24),
        Text('جميع الخدمات', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        SizedBox(height: Insets.s12),
        ...searchableItems.map((item) => SearchResultTile(
              title: item['title'] as String, subtitle: item['subtitle'] as String,
              icon: item['icon'] as IconData, category: item['category'] as String,
              onTap: () => _navigate(item['route'] as String),
            )),
      ];

  List<Widget> _buildEmptyResults() => [
        SizedBox(height: 80.h),
        Icon(Icons.search_off_rounded, size: 48.sp, color: const Color(0xFFD9DADB)),
        SizedBox(height: Insets.s12),
        Center(child: Text('لا توجد نتائج', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16))),
        SizedBox(height: 4.h),
        Center(child: Text('حاول البحث بكلمة مختلفة', style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14))),
      ];

  List<Widget> _buildResults(String query) => [
        SizedBox(height: Insets.s16),
        Text('نتائج البحث (${_results.length})', style: getMediumStyle(color: const Color(0xFF838485), fontSize: FontSize.s14)),
        SizedBox(height: Insets.s12),
        ..._results.map((item) => SearchResultTile(
              title: item['title'] as String, subtitle: item['subtitle'] as String,
              icon: item['icon'] as IconData, category: item['category'] as String,
              highlightQuery: query, onTap: () => _navigate(item['route'] as String),
            )),
      ];
}
