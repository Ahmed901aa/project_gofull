import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
            _tab(context, 0, S.of(context).savingsList),
            _tab(context, 1, S.of(context).previousCodes),
          ],
        ),
        Container(height: 1, color: context.colors.border),
      ],
    );
  }

  Widget _tab(BuildContext context, int index, String label) => Expanded(
        child: GestureDetector(
          onTap: () => onTabChanged(index),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s18)),
                SizedBox(height: 4.h),
                Container(
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: selectedTab == index ? context.colors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.s24),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
