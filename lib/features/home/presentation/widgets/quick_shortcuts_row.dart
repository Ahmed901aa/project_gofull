import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'search_data.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
            padding: EdgeInsetsDirectional.only(start: isLast ? 0 : Insets.s8),
            child: GestureDetector(
              onTap: () => onNavigate(s['route'] as String),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Insets.s12),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                  border: Border.all(color: context.colors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(s['icon'] as IconData, size: 20.sp, color: context.colors.primary),
                    ),
                    SizedBox(height: Insets.s8),
                    Text(
                      s['title'] as String,
                      style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s12),
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
