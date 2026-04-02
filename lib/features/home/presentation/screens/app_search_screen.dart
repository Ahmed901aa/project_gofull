import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';

// replace with real data later
const _searchableItems = [
  {'title': 'إمداد وقود', 'subtitle': 'توصيل الوقود لموقعك', 'icon': Icons.local_gas_station_outlined, 'route': Routes.fuelType},
  {'title': 'ونش', 'subtitle': 'خدمة سحب السيارات', 'icon': Icons.fire_truck_outlined, 'route': Routes.towingRequest},
  {'title': 'طلباتي', 'subtitle': 'عرض الطلبات الحالية والسابقة', 'icon': Icons.receipt_long_outlined, 'route': '_orders'},
  {'title': 'أكواد الخصم', 'subtitle': 'إدخال وعرض أكواد الخصم', 'icon': Icons.local_offer_outlined, 'route': Routes.discountCodes},
  {'title': 'الأسئلة الشائعة', 'subtitle': 'إجابات على الأسئلة المتكررة', 'icon': Icons.help_outline_rounded, 'route': Routes.faq},
  {'title': 'تعديل بيانات الحساب', 'subtitle': 'تعديل الاسم ورقم الجوال', 'icon': Icons.person_outline_rounded, 'route': Routes.editProfile},
  {'title': 'الشروط والأحكام', 'subtitle': 'شروط استخدام التطبيق', 'icon': Icons.description_outlined, 'route': Routes.terms},
  {'title': 'الدعم والمساعدة', 'subtitle': 'تواصل معنا للمساعدة', 'icon': Icons.headset_mic_outlined, 'route': '_support'},
];

// Keywords for better matching
const _searchKeywords = {
  'إمداد وقود': ['وقود', 'بنزين', 'ديزل', 'تعبئة', 'طلب وقود'],
  'ونش': ['ونش', 'سحب', 'نقل', 'طلب ونش', 'سيارة'],
  'طلباتي': ['طلبات', 'طلب', 'سجل', 'تاريخ'],
  'أكواد الخصم': ['كود', 'خصم', 'عرض', 'تخفيض', 'كوبون'],
  'الأسئلة الشائعة': ['سؤال', 'أسئلة', 'مساعدة', 'كيف'],
  'تعديل بيانات الحساب': ['تعديل', 'حساب', 'اسم', 'رقم', 'جوال', 'بيانات'],
  'الشروط والأحكام': ['شروط', 'أحكام', 'سياسة'],
  'الدعم والمساعدة': ['دعم', 'مساعدة', 'تواصل', 'شكوى'],
};

const _quickShortcuts = [
  {'title': 'إمداد وقود', 'route': Routes.fuelType},
  {'title': 'ونش', 'route': Routes.towingRequest},
  {'title': 'طلباتي', 'route': '_orders'},
  {'title': 'الدعم', 'route': '_support'},
];

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
      _results = _searchableItems.where((item) {
        final title = item['title'] as String;
        final subtitle = item['subtitle'] as String;
        if (title.contains(query) || subtitle.contains(query)) return true;
        final keywords = _searchKeywords[title] ?? [];
        return keywords.any((k) => k.contains(query));
      }).toList().cast<Map<String, dynamic>>();
    });
  }

  void _navigate(String route) {
    if (route == '_orders') {
      // Go back to home and switch to orders tab
      Navigator.pop(context, 1);
      return;
    }
    if (route == '_support') {
      Navigator.pop(context);
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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (query.isEmpty) ...[
                      SizedBox(height: Insets.s16),
                      _buildQuickShortcuts(),
                    ],
                    if (query.isNotEmpty && _results.isEmpty) ...[
                      SizedBox(height: 48.h),
                      Center(
                        child: Text(
                          'لا توجد نتائج',
                          style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s16),
                        ),
                      ),
                    ],
                    if (_results.isNotEmpty) ...[
                      SizedBox(height: Insets.s8),
                      ..._results.map((item) => _SearchResultTile(
                            title: item['title'] as String,
                            subtitle: item['subtitle'] as String,
                            icon: item['icon'] as IconData,
                            onTap: () => _navigate(item['route'] as String),
                          )),
                    ],
                  ],
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
                  SizedBox(width: Insets.s12),
                  Expanded(
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F9),
                        borderRadius: BorderRadius.circular(AppRadius.s16),
                        border: Border.all(color: const Color(0xFFEFF0F1)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, size: 20.sp, color: const Color(0xFF838485)),
                          SizedBox(width: Insets.s8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'ابحث عن خدمة، طلب، أو مساعدة...',
                                hintStyle: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            GestureDetector(
                              onTap: () => _controller.clear(),
                              child: Icon(Icons.close_rounded, size: 18.sp, color: const Color(0xFF838485)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildQuickShortcuts() => Wrap(
        spacing: Insets.s8,
        runSpacing: Insets.s8,
        children: _quickShortcuts.map((s) => GestureDetector(
              onTap: () => _navigate(s['route'] as String),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.s24),
                  border: Border.all(color: const Color(0xFFEFF0F1)),
                ),
                child: Text(
                  s['title'] as String,
                  style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                ),
              ),
            )).toList(),
      );
}

class _SearchResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
        margin: EdgeInsets.only(bottom: Insets.s8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: const Color(0xFFEFF0F1)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Icon(icon, size: 20.sp, color: AppColors.primary),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14)),
                ],
              ),
            ),
            Icon(Icons.arrow_back_ios_new_rounded, size: 14.sp, color: const Color(0xFF838485)),
          ],
        ),
      ),
    );
  }
}
