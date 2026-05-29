import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class DriverReportsScreen extends StatefulWidget {
  const DriverReportsScreen({super.key});

  @override
  State<DriverReportsScreen> createState() => _DriverReportsScreenState();
}

class _DriverReportsScreenState extends State<DriverReportsScreen> {
  bool _isLoading = true;
  String? _error;

  // Stats
  int _totalOrders = 0;
  double _totalIncome = 0;
  double _averageRating = 0;
  int _totalRatings = 0;
  int _todayOrders = 0;
  double _todayIncome = 0;
  int _ordersChange = 0;
  int _incomeChange = 0;

  // Chart data
  Map<String, double> _barData = {};
  List<_ChartPoint> _areaData = [];

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final response =
          await sl<ApiClient>().dio.get(ApiConstants.providerAnalytics);
      final data = response.data['data'] as Map<String, dynamic>;

      if (mounted) {
        setState(() {
          _totalOrders = int.tryParse('${data['total_orders'] ?? ''}') ?? 0;
          _totalIncome = double.tryParse('${data['total_income'] ?? ''}') ?? 0;
          _todayOrders = int.tryParse('${data['today_orders'] ?? ''}') ?? 0;
          _todayIncome = double.tryParse('${data['today_income'] ?? ''}') ?? 0;
          _ordersChange = int.tryParse('${data['orders_change'] ?? ''}') ?? 0;
          _incomeChange = int.tryParse('${data['income_change'] ?? ''}') ?? 0;
          _averageRating = double.tryParse('${data['average_rating'] ?? ''}') ?? 0;
          _totalRatings = int.tryParse('${data['total_ratings'] ?? ''}') ?? 0;

          // Parse weekly orders for bar chart
          final weeklyOrders =
              data['weekly_orders'] as List<dynamic>? ?? [];
          _barData = {
            for (final item in weeklyOrders)
              (item['day'] as String):
                  double.tryParse('${item['count'] ?? 0}') ?? 0,
          };

          // Parse weekly acceptance for area chart
          final weeklyAcceptance =
              data['weekly_acceptance'] as List<dynamic>? ?? [];
          _areaData = weeklyAcceptance
              .map((item) => _ChartPoint(
                    label: ('${item['day'] ?? ''}').isNotEmpty ? '${item['day']}'.substring(0, 1) : '',
                    value: double.tryParse('${item['rate'] ?? 0}') ?? 0,
                  ))
              .toList();

          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        final statusCode = e.response?.statusCode;
        final message = (e.response?.data as Map?)?['message'] as String?;
        setState(() {
          if (statusCode == 403) {
            _error = message ?? S.of(context).accountUnderReview;
          } else if (statusCode == 404) {
            _error = S.of(context).analyticsNotFound;
          } else {
            _error = S.of(context).failedToLoadReports;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = S.of(context).failedToLoadReports;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline_rounded,
                                  size: 48.sp, color: context.colors.iconSecondary),
                              SizedBox(height: Insets.s8),
                              Text(_error!,
                                  style: getRegularStyle(
                                      color: context.colors.iconSecondary,
                                      fontSize: FontSize.s16)),
                              SizedBox(height: Insets.s16),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _error = null;
                                  });
                                  _loadAnalytics();
                                },
                                child: Text(S.of(context).retryButton),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });
                            await _loadAnalytics();
                          },
                          child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          padding: EdgeInsets.all(Insets.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _StatCard(
                                icon: Icons.route_rounded,
                                iconBg: context.colors.primarySurface,
                                iconColor: context.colors.primary,
                                title: S.of(context).totalOrdersLabel,
                                value: '$_totalOrders',
                                changePercent: '${_ordersChange.abs()}%',
                                changeLabel: S.of(context).fromYesterdayLabel,
                                isPositive: _ordersChange >= 0,
                              ),
                              SizedBox(height: Insets.s12),
                              _StatCard(
                                icon: Icons.account_balance_wallet_rounded,
                                iconBg:
                                    context.colors.gold.withValues(alpha: 0.1),
                                iconColor: context.colors.gold,
                                title: S.of(context).totalIncomeLabel,
                                value:
                                    '${_totalIncome.toStringAsFixed(2)} ${S.of(context).currencyDL}',
                                changePercent: '${_incomeChange.abs()}%',
                                changeLabel: S.of(context).fromYesterdayLabel,
                                isPositive: _incomeChange >= 0,
                              ),
                              SizedBox(height: Insets.s12),
                              _StatCard(
                                icon: Icons.star_rounded,
                                iconBg:
                                    context.colors.gold.withValues(alpha: 0.1),
                                iconColor: context.colors.gold,
                                title: S.of(context).averageRatingLabel,
                                value: _averageRating > 0
                                    ? '${_averageRating.toStringAsFixed(1)} / 5'
                                    : '—',
                                changePercent: '$_totalRatings',
                                changeLabel: S.of(context).ratingLabel,
                                isPositive: true,
                              ),
                              SizedBox(height: Insets.s12),
                              _StatCard(
                                icon: Icons.today_rounded,
                                iconBg:
                                    context.colors.info.withValues(alpha: 0.1),
                                iconColor: context.colors.info,
                                title: S.of(context).todayIncomeLabel,
                                value:
                                    '${_todayIncome.toStringAsFixed(2)} ${S.of(context).currencyDL}',
                                changePercent: '$_todayOrders',
                                changeLabel: S.of(context).orderTodayLabel,
                                isPositive: true,
                              ),

                              SizedBox(height: Insets.s24),

                              // ── Task Productivity Chart ──
                              if (_barData.isNotEmpty)
                                _ChartSection(
                                  title: S.of(context).weeklyOrdersLabel,
                                  child: _BarChart(data: _barData),
                                ),

                              if (_barData.isNotEmpty)
                                SizedBox(height: Insets.s24),

                              // ── Response Rate Chart ──
                              if (_areaData.isNotEmpty)
                                _ChartSection(
                                  title: S.of(context).acceptRateLabel,
                                  child: _AreaChart(data: _areaData),
                                ),

                              SizedBox(height: Insets.s24),
                            ],
                          ),
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
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(backArrowIcon(context),
                        size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).reportsTitle,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s20),
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

// ── Chart Point ─────────────────────────────────────────

class _ChartPoint {
  final String label;
  final double value;
  const _ChartPoint({required this.label, required this.value});
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                      color: context.colors.iconSecondary, fontSize: FontSize.s14),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 14.sp,
                      color: isPositive ? context.colors.success : context.colors.error,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '$changePercent $changeLabel',
                      style: getRegularStyle(
                        color: isPositive ? context.colors.success : context.colors.error,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            value,
            style: getBoldStyle(
                color: context.colors.textPrimary, fontSize: FontSize.s18),
          ),
        ],
      ),
    );
  }
}

// ── Chart Section Wrapper ────────────────────────────────

class _ChartSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: getBoldStyle(
                color: context.colors.textPrimary, fontSize: FontSize.s16),
          ),
          SizedBox(height: Insets.s16),
          child,
        ],
      ),
    );
  }
}

// ── Bar Chart (Weekly Orders) ───────────────────────────

class _BarChart extends StatelessWidget {
  final Map<String, double> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {

      return const SizedBox.shrink();

    }

    final maxVal = data.values.reduce((a, b) => a > b ? a : b);
    final peakEntry = data.entries.reduce((a, b) => a.value > b.value ? a : b);

    return SizedBox(
      height: 200.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.entries.map((entry) {
          final isPeak = entry.key == peakEntry.key;
          final ratio = maxVal > 0 ? entry.value / maxVal : 0.0;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isPeak && entry.value > 0) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s4, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Text(
                        '${entry.value.toInt()}',
                        style: getMediumStyle(
                            color: context.colors.surface, fontSize: FontSize.s12),
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Container(
                    height: (160.h * ratio).clamp(4.0, 160.h),
                    decoration: BoxDecoration(
                      color: isPeak ? context.colors.primary : context.colors.primaryLight,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.s8),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    entry.key,
                    style:
                        getRegularStyle(color: context.colors.iconSecondary, fontSize: 9.sp),
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

// ── Area Chart (Acceptance Rate) ────────────────────────

class _AreaChart extends StatelessWidget {
  final List<_ChartPoint> data;
  const _AreaChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final values = data.map((e) => e.value).toList();
    final labels = data.map((e) => e.label).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded,
                    size: 14.sp, color: context.colors.success),
                SizedBox(width: 4.w),
                Text(
                  S.of(context).weeklyAcceptanceRateLabel,
                  style: getMediumStyle(
                      color: context.colors.success, fontSize: FontSize.s12),
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
              values: values,
              lineColor: context.colors.primary,
              fillColor: context.colors.primary.withValues(alpha: 0.1),
            ),
            size: Size(double.infinity, 160.h),
          ),
        ),
        SizedBox(height: Insets.s8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels
              .map((l) => Text(
                    l,
                    style: getRegularStyle(
                        color: context.colors.iconSecondary, fontSize: FontSize.s12),
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
    if (values.isEmpty) {

      return;

    }

    final maxVal = values.reduce(math.max);
    final minVal = values.reduce(math.min);
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    final points = <Offset>[];
    final stepX = size.width / (values.length - 1);

    for (var i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y =
          size.height - ((values[i] - minVal) / range) * size.height * 0.85;
      points.add(Offset(x, y));
    }

    final fillPath = Path()..moveTo(0, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, Paint()..color = fillColor);

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

    for (final p in points) {
      canvas.drawCircle(p, 4, Paint()..color = lineColor);
      canvas.drawCircle(p, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
