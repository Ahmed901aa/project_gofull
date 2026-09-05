import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/cubits/theme_cubit.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Shows a bottom sheet with Light / Dark theme options.
/// Returns `true` if the user changed the theme, `false` otherwise.
Future<bool> showThemeSelectorSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: context.read<ThemeCubit>(),
      child: const _ThemeSelectorContent(),
    ),
  );
  return result ?? false;
}

class _ThemeSelectorContent extends StatelessWidget {
  const _ThemeSelectorContent();

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final cubit = context.watch<ThemeCubit>();
    final current = cubit.appThemeMode;

    final options = [
      _ThemeOption(
        mode: AppThemeMode.light,
        icon: Icons.light_mode_rounded,
        label: l10n.themeLight,
        isSelected: current == AppThemeMode.light,
      ),
      _ThemeOption(
        mode: AppThemeMode.dark,
        icon: Icons.dark_mode_rounded,
        label: l10n.themeDark,
        isSelected: current == AppThemeMode.dark,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(Insets.s16, 12.h, Insets.s16, Insets.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: Insets.s16),

              // Title
              Text(
                l10n.appearance,
                style: getBoldStyle(
                  color: context.colors.textPrimary,
                  fontSize: FontSize.s18,
                ),
              ),
              SizedBox(height: Insets.s20),

              // Three-option row
              Row(
                children: options
                    .map((opt) => Expanded(
                          child: _ThemeTile(
                            option: opt,
                            onTap: () {
                              if (opt.mode != current) {
                                cubit.setThemeMode(opt.mode);
                                Navigator.pop(context, true);
                              } else {
                                Navigator.pop(context, false);
                              }
                            },
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: Insets.s16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption {
  final AppThemeMode mode;
  final IconData icon;
  final String label;
  final bool isSelected;

  const _ThemeOption({
    required this.mode,
    required this.icon,
    required this.label,
    required this.isSelected,
  });
}

class _ThemeTile extends StatelessWidget {
  final _ThemeOption option;
  final VoidCallback onTap;

  const _ThemeTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = option.isSelected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: Insets.s12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primarySurface
              : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              size: 28.sp,
              color: isSelected
                  ? context.colors.primary
                  : context.colors.iconSecondary,
            ),
            SizedBox(height: 8.h),
            Text(
              option.label,
              style: getMediumStyle(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.textPrimary,
                fontSize: FontSize.s14,
              ),
            ),
            SizedBox(height: 6.h),
            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.border,
                  width: isSelected ? 5 : 1.5,
                ),
                color: isSelected
                    ? context.colors.surface
                    : context.colors.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
