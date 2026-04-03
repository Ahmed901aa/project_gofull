import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DriverReportsScreen extends StatefulWidget {
  const DriverReportsScreen({super.key});

  @override
  State<DriverReportsScreen> createState() => _DriverReportsScreenState();
}

class _DriverReportsScreenState extends State<DriverReportsScreen> {
  String _productivityFilter = 'يومي';
  String _responseFilter = 'يومي';

  final _filterOptions = const [
    'اليوم',
    'يومي',
    'هذا الإسبوع',
    'هذا الشهر',
    'ستة أشهر',
    'سنوياً',
  ];

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    _StatCard(
                      icon: Icons.access_time_rounded,
                      iconBg: AppColors.primary50,
                      iconColor: AppColors.primary,
                      title: 'ساعات العمل',
                      value: '255',
                      changePercent: '10%',
                      changeLabel: 'من أمس',
                      isPositive: true,
                    ),
                    SizedBox(height: Insets.s12),
                    _StatCard(
                      icon: Icons.route_rounded,
                      iconBg: AppColors.gold.withValues(alpha: 0.1),
                      iconColor: AppColors.gold,
                      title: 'إجمالي الرحلات',
                      value: '2500.5 ج.م',
                      changePercent: '10%',
                      changeLabel: 'من أمس',
                      isPositive: false,
                    ),
                    SizedBox(height: Insets.s12),
                    _StatCard(
                      icon: Icons.star_rounded,
                      iconBg: AppColors.gold.withValues(alpha: 0.1),
                      iconColor: AppColors.gold,
                      title: 'متوسط التقييم',
                      value: '4.25 / 5',
                      changePercent: '10%',
                      changeLabel: 'من أمس',
                      isPositive: true,
                    ),
                    SizedBox(height: Insets.s12),
                    _StatCard(
                      icon: Icons.straighten_rounded,
                      iconBg: AppColors.info.withValues(alpha: 0.1),
                      iconColor: AppColors.info,
                      title: 'المسافة المقطوعة',
                      value: '250 كم',
                      changePercent: '10%',
                      changeLabel: 'من أمس',
                      isPositive: true,
                    ),

                    SizedBox(height: Insets.s24),

                    // ── Task Productivity Chart ──
                    _ChartSection(
                      title: 'إنتاجية المهام',
                      selectedFilter: _productivityFilter,
                      filters: _filterOptions,
                      onFilterChanged: (v) =>
                          setState(() => _productivityFilter = v),
                      child: _BarChart(),
                    ),

                    SizedBox(height: Insets.s24),

                    // ── Response Rate Chart ──
                    _ChartSection(
                      title: 'معدل الاستجابة',
                      selectedFilter: _responseFilter,
                      filters: _filterOptions,
                      onFilterChanged: (v) =>
                          setState(() => _responseFilter = v),
                      child: _AreaChart(),
                    ),

                    SizedBox(height: Insets.s24),
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
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'التقارير',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
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

// ── Stat Card ────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;
  final String changePercent;
  final String changeLabel;
  final bool isPositive;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.changePercent,
    required this.changeLabel,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 24.sp, color: iconColor),
          ),
          SizedBox(width: Insets.s12),
          // Title + change
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                      color: AppColors.grey, fontSize: FontSize.s14),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 14.sp,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '$changePercent $changeLabel',
                      style: getRegularStyle(
                        color: isPositive ? AppColors.success : AppColors.error,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Value
          Text(
            value,
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          ),
        ],
      ),
    );
  }
}

// ── Chart Section Wrapper ────────────────────────────────

class _ChartSection extends StatelessWidget {
  final String title;
  final String selectedFilter;
  final List<String> filters;
  final ValueChanged<String> onFilterChanged;
  final Widget child;

  const _ChartSection({
    required this.title,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                title,
                style: getBoldStyle(
                    color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
              ),
              const Spacer(),
              _FilterDropdown(
                value: selectedFilter,
                items: filters,
                onChanged: onFilterChanged,
              ),
            ],
          ),
          SizedBox(height: Insets.s16),
          child,
        ],
      ),
    );
  }
}

// ── Filter Dropdown ──────────────────────────────────────

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s8),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 18.sp, color: AppColors.darkGrey),
          style: getMediumStyle(
              color: AppColors.darkGrey, fontSize: FontSize.s12),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ── Bar Chart (Task Productivity) ────────────────────────

// replace with API data later
const _barData = <String, double>{
  'السبت': 28,
  'الأحد': 42,
  'الاثنين': 35,
  'الثلاثاء': 55,
  'الأربعاء': 48,
  'الخميس': 30,
  'الجمعة': 20,
};

class _BarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final maxVal =
        _barData.values.reduce((a, b) => a > b ? a : b);
    final peakEntry =
        _barData.entries.reduce((a, b) => a.value > b.value ? a : b);

    return SizedBox(
      height: 200.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _barData.entries.map((entry) {
          final isPeak = entry.key == peakEntry.key;
          final ratio = entry.value / maxVal;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isPeak) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s4, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Text(
                        '${entry.value.toInt()}',
                        style: getMediumStyle(
                            color: AppColors.white, fontSize: FontSize.s12),
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Container(
                    height: (160.h * ratio).clamp(8.0, 160.h),
                    decoration: BoxDecoration(
                      color: isPeak ? AppColors.primary : AppColors.primary200,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.s8),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    entry.key,
                    style: getRegularStyle(
                        color: AppColors.grey, fontSize: 9.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Area Chart (Response Rate) ───────────────────────────

// replace with API data later
const _areaValues = [30.0, 45.0, 38.0, 60.0, 52.0, 70.0, 55.0];
const _areaLabels = ['س', 'أ', 'إ', 'ث', 'أ', 'خ', 'ج'];

class _AreaChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Badge
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded,
                    size: 14.sp, color: AppColors.success),
                SizedBox(width: 4.w),
                Text(
                  'أعلى معدل قبول',
                  style: getMediumStyle(
                      color: AppColors.success, fontSize: FontSize.s12),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: Insets.s12),
        SizedBox(
          height: 160.h,
          child: CustomPaint(
            painter: _AreaChartPainter(
              values: _areaValues,
              lineColor: AppColors.primary,
              fillColor: AppColors.primary.withValues(alpha: 0.1),
            ),
            size: Size(double.infinity, 160.h),
          ),
        ),
        SizedBox(height: Insets.s8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _areaLabels
              .map((l) => Text(
                    l,
                    style: getRegularStyle(
                        color: AppColors.grey, fontSize: FontSize.s12),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  _AreaChartPainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxVal = values.reduce(math.max);
    final minVal = values.reduce(math.min);
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    final points = <Offset>[];
    final stepX = size.width / (values.length - 1);

    for (var i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - ((values[i] - minVal) / range) * size.height * 0.85;
      points.add(Offset(x, y));
    }

    // Fill path
    final fillPath = Path()..moveTo(0, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()..color = fillColor,
    );

    // Line
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots
    for (final p in points) {
      canvas.drawCircle(
        p,
        4,
        Paint()..color = lineColor,
      );
      canvas.drawCircle(
        p,
        2,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
