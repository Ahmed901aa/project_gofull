import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'search_data.dart';

class QuickShortcutsRow extends StatelessWidget {
  final void Function(String route) onNavigate;
  const QuickShortcutsRow({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final shortcuts = getQuickShortcuts(context);
    return Row(
      children: shortcuts.map((s) {
        final isLast = s == shortcuts.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: isLast ? 0 : Insets.s8),
            child: GestureDetector(
              onTap: () => onNavigate(s['route'] as String),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Insets.s12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                  border: Border.all(color: const Color(0xFFEFF0F1)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(s['icon'] as IconData, size: 20.sp, color: AppColors.primary),
                    ),
                    SizedBox(height: Insets.s8),
                    Text(
                      s['title'] as String,
                      style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
