import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/cubits/theme_cubit.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final cubit = context.watch<ThemeCubit>();
    final isDark = cubit.appThemeMode == AppThemeMode.dark;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          AppHeader(title: l10n.appearance),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                children: [
                  _ToggleTile(
                    icon: Icons.dark_mode_rounded,
                    label: l10n.darkThemeToggle,
                    value: isDark,
                    onChanged: (on) {
                      cubit.setThemeMode(
                        on ? AppThemeMode.dark : AppThemeMode.light,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22.sp, color: context.colors.primary),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: getMediumStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Insets.s8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}
