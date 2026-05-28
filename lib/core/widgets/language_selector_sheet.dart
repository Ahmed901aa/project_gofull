import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/cubits/locale_cubit.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Shows a polished language selection bottom sheet.
///
/// Returns `true` if the language was changed, `false` otherwise.
Future<bool> showLanguageSelectorSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<LocaleCubit>(),
      child: const _LanguageSelectorContent(),
    ),
  );
  return result ?? false;
}

class _LanguageSelectorContent extends StatefulWidget {
  const _LanguageSelectorContent();

  @override
  State<_LanguageSelectorContent> createState() =>
      _LanguageSelectorContentState();
}

class _LanguageSelectorContentState extends State<_LanguageSelectorContent> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<LocaleCubit>().state.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocaleCubit>();
    final current = cubit.state.languageCode;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
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
                color: const Color(0xFFD9DADB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16.h),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.language_rounded,
                    color: AppColors.primary, size: 22.sp),
                SizedBox(width: 8.w),
                Text(
                  'Language / اللغة',
                  style: getBoldStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: FontSize.s18),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Arabic option
            _LanguageOption(
              flag: '🇱🇾',
              title: 'العربية',
              subtitle: 'Arabic',
              isSelected: _selected == 'ar',
              onTap: () => setState(() => _selected = 'ar'),
            ),
            SizedBox(height: 10.h),
            // English option
            _LanguageOption(
              flag: '🇬🇧',
              title: 'English',
              subtitle: 'الإنجليزية',
              isSelected: _selected == 'en',
              onTap: () => setState(() => _selected = 'en'),
            ),
            SizedBox(height: 24.h),
            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selected != current) {
                    await cubit.setLocale(Locale(_selected));
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } else {
                    Navigator.pop(context, false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _selected != current
                      ? (_selected == 'ar' ? 'تأكيد' : 'Confirm')
                      : (current == 'ar' ? 'إغلاق' : 'Close'),
                  style: getBoldStyle(
                      color: AppColors.white, fontSize: FontSize.s16),
                ),
              ),
            ),
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
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFEFF0F1),
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
                          ? AppColors.primary
                          : const Color(0xFF0E0E0E),
                      fontSize: FontSize.s16,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: AppColors.grey,
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
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded,
                      color: AppColors.white, size: 16.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
