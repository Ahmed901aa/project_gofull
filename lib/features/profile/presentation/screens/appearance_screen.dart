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
    final appMode = cubit.appThemeMode;
    final isSystem = appMode == AppThemeMode.system;

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
                  // ── Toggle 1: Match System Theme ──
                  _ToggleTile(
                    icon: Icons.settings_brightness_rounded,
                    label: l10n.matchSystemTheme,
                    subtitle: l10n.matchSystemThemeDesc,
                    value: isSystem,
                    onChanged: (on) {
                      if (on) {
                        cubit.setThemeMode(AppThemeMode.system);
                      } else {
                        // Turning off system → default to light
                        cubit.setThemeMode(
                          cubit.isDark ? AppThemeMode.dark : AppThemeMode.light,
                        );
                      }
                    },
                  ),
                  // ── Toggle 2: Dark Theme (only when system is OFF) ──
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: isSystem
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              SizedBox(height: Sizes.s12),
                              _ToggleTile(
                                icon: Icons.dark_mode_rounded,
                                label: l10n.darkThemeToggle,
                                value: appMode == AppThemeMode.dark,
                                onChanged: (on) {
                                  cubit.setThemeMode(
                                    on ? AppThemeMode.dark : AppThemeMode.light,
                                  );
                                },
                              ),
                            ],
                          ),
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
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    this.subtitle,
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
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: getRegularStyle(
                      color: context.colors.textSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: Insets.s8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}
