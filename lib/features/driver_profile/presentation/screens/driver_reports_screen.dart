import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/service_header.dart';

class DriverReportsScreen extends StatefulWidget {
  const DriverReportsScreen({super.key});

  @override
  State<DriverReportsScreen> createState() => _DriverReportsScreenState();
}

class _DriverReportsScreenState extends State<DriverReportsScreen> {
  String _selectedFilter = AppStrings.today;

  static const List<String> _filters = [
    AppStrings.today,
    AppStrings.thisWeek,
    AppStrings.thisMonth,
    AppStrings.sixMonths,
    AppStrings.yearly,
  ];

  static const List<String> _weekDays = [
    'سبت',
    'أحد',
    'إثنين',
    'ثلاثاء',
    'أربعاء',
    'خميس',
    'جمعة',
  ];

  static const List<double> _barValues = [0.4, 0.7, 0.55, 0.85, 0.65, 0.9, 0.3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: AppStrings.reports),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFilterRow(),
                  SizedBox(height: Sizes.s16),
                  _buildStatsGrid(),
                  SizedBox(height: Sizes.s24),
                  _buildProductivitySection(),
                  SizedBox(height: Sizes.s24),
                  _buildResponseRateSection(),
                  SizedBox(height: Sizes.s32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: Insets.s8),
        itemBuilder: (_, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.s24),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.neutral600,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: getMediumStyle(
                  color: isSelected ? AppColors.white : AppColors.neutral800,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                label: AppStrings.workHours,
                value: '8.5',
                changeText: '${AppStrings.fromYesterday} 12%',
                changeIcon: Icons.arrow_upward_rounded,
                changeColor: AppColors.success,
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: _statCard(
                label: AppStrings.totalTrips,
                value: '12',
                changeText: '${AppStrings.fromYesterday} 5%',
                changeIcon: Icons.arrow_upward_rounded,
                changeColor: AppColors.success,
              ),
            ),
          ],
        ),
        SizedBox(height: Sizes.s12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                label: AppStrings.averageRating,
                value: '4.8',
                trailing: Icon(
                  Icons.star_rounded,
                  size: 18.sp,
                  color: AppColors.gold,
                ),
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: _statCard(
                label: AppStrings.distanceCovered,
                value: '156 كم',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    String? changeText,
    IconData? changeIcon,
    Color? changeColor,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: Sizes.s8),
          Row(
            children: [
              Text(
                value,
                style: getBoldStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s22,
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: Insets.s4),
                trailing,
              ],
            ],
          ),
          if (changeText != null) ...[
            SizedBox(height: Sizes.s4),
            Row(
              children: [
                if (changeIcon != null)
                  Icon(changeIcon, size: 14.sp, color: changeColor),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    changeText,
                    style: getRegularStyle(
                      color: changeColor ?? AppColors.grey,
                      fontSize: FontSize.s12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductivitySection() {
    final maxBarHeight = 120.h;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskProductivity,
          style: getBoldStyle(
            color: AppColors.black,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(height: Sizes.s12),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: maxBarHeight + 30.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_weekDays.length, (index) {
                    final barHeight = maxBarHeight * _barValues[index];
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 24.w,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: index == 5
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(AppRadius.s8),
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.s8),
                          Text(
                            _weekDays[index],
                            style: getRegularStyle(
                              color: AppColors.grey,
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponseRateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.responseRate,
          style: getBoldStyle(
            color: AppColors.black,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(height: Sizes.s12),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: Insets.s8),
                  Text(
                    AppStrings.highestAcceptRate,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Sizes.s12),
              Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: _AreaChartPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.3),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.5),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.45, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width, size.height * 0.35),
    ];

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
