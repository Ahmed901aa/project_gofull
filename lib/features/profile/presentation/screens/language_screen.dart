import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/cubits/locale_cubit.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.isArabic;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          AppHeader(title: l10n.selectLanguage),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                children: [
                  _LanguageOption(
                    label: 'العربية',
                    subtitle: 'Arabic',
                    isSelected: isArabic,
                    onTap: () {
                      if (!isArabic) localeCubit.toggleLocale();
                    },
                  ),
                  SizedBox(height: Sizes.s12),
                  _LanguageOption(
                    label: 'English',
                    subtitle: 'الإنجليزية',
                    isSelected: !isArabic,
                    onTap: () {
                      if (isArabic) localeCubit.toggleLocale();
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

class _LanguageOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primarySurface : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: getBoldStyle(
                      color: isSelected ? context.colors.primary : context.colors.textPrimary,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: context.colors.textSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? context.colors.primary : context.colors.border,
                  width: isSelected ? 6 : 1.5,
                ),
                color: context.colors.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
