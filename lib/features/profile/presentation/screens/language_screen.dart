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

/// Minimal language picker: a single list of language names with a check mark
/// next to the active one.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final cubit = context.watch<LocaleCubit>();
    final isArabic = cubit.isArabic;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          AppHeader(title: l10n.selectLanguage),
          SizedBox(height: Sizes.s24),

          // Icon + word above the list
          Icon(
            Icons.language_rounded,
            color: context.colors.primary,
            size: 36.sp,
          ),
          SizedBox(height: Sizes.s8),
          Text(
            l10n.selectLanguage,
            style: getBoldStyle(
              color: context.colors.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),

          SizedBox(height: Sizes.s20),
          _LanguageRow(
            title: 'العربية',
            isSelected: isArabic,
            onTap: () {
              if (!isArabic) cubit.toggleLocale();
            },
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
          _LanguageRow(
            title: 'English',
            isSelected: !isArabic,
            onTap: () {
              if (isArabic) cubit.toggleLocale();
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: context.colors.surface,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: Insets.s16,
          vertical: 18.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: getMediumStyle(
                  color: context.colors.textPrimary,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: context.colors.primary,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}
