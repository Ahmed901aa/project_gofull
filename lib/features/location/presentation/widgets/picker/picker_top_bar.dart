import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PickerTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSearchTap;

  const PickerTopBar({
    super.key,
    required this.onBack,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40.w, height: 40.w,
              decoration: BoxDecoration(
                color: context.colors.surface,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 8)],
              ),
              child: Icon(Icons.arrow_back, size: 20.sp, color: context.colors.textPrimary),
            ),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: Insets.s12),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: context.colors.primary, size: 20.sp),
                    SizedBox(width: Insets.s8),
                    Text(S.of(context).searchForLocationDots,
                        style: getRegularStyle(color: context.colors.iconSecondary, fontSize: FontSize.s14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
