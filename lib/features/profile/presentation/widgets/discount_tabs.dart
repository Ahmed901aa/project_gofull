import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DiscountTabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  const DiscountTabs({super.key, required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _tab(0, 'قائمة التوفير'),
            _tab(1, 'أكواد سابقة'),
          ],
        ),
        Container(height: 1, color: AppColors.neutral600),
      ],
    );
  }

  Widget _tab(int index, String label) => Expanded(
        child: GestureDetector(
          onTap: () => onTabChanged(index),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
                SizedBox(height: 4.h),
                Container(
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: selectedTab == index ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.s24),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
