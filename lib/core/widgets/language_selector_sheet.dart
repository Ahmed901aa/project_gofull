import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/cubits/locale_cubit.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Shows a minimal language selection bottom sheet.
///
/// Tapping a language applies it instantly and closes.
/// Returns `true` if the language was changed, `false` otherwise.
Future<bool> showLanguageSelectorSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<LocaleCubit>(),
      child: const _LanguageSelectorContent(),
    ),
  );
  return result ?? false;
}

class _LanguageSelectorContent extends StatelessWidget {
  const _LanguageSelectorContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LocaleCubit>();
    final current = cubit.state.languageCode;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
      ),
      padding: EdgeInsets.fromLTRB(Insets.s16, 8.h, Insets.s16, Insets.s16),
      child: SafeArea(
        top: false,
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
            SizedBox(height: 16.h),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.language_rounded,
                    color: context.colors.primary, size: 22.sp),
                SizedBox(width: 8.w),
                Text(
                  'Language / اللغة',
                  style: getBoldStyle(
                      color: context.colors.textPrimary,
                      fontSize: FontSize.s18),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Arabic — one tap applies instantly
            _LanguageOption(
              flag: '🇱🇾',
              title: 'العربية',
              subtitle: 'Arabic',
              isSelected: current == 'ar',
              onTap: () async {
                if (current != 'ar') {
                  await cubit.setLocale(const Locale('ar'));
                }
                if (context.mounted) {
                  Navigator.pop(context, current != 'ar');
                }
              },
            ),
            SizedBox(height: 10.h),
            // English — one tap applies instantly
            _LanguageOption(
              flag: '🇬🇧',
              title: 'English',
              subtitle: 'الإنجليزية',
              isSelected: current == 'en',
              onTap: () async {
                if (current != 'en') {
                  await cubit.setLocale(const Locale('en'));
                }
                if (context.mounted) {
                  Navigator.pop(context, current != 'en');
                }
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.title,
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
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary.withValues(alpha: 0.06)
              : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag
            Text(flag, style: TextStyle(fontSize: 28.sp)),
            SizedBox(width: 14.w),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.textPrimary,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: context.colors.iconSecondary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? context.colors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? context.colors.primary : context.colors.border,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded,
                      color: context.colors.surface, size: 16.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
