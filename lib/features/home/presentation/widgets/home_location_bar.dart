import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(Insets.s16, 0, Insets.s16, Insets.s16),
        child: Container(
          width: double.infinity,
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          decoration: BoxDecoration(
            color: context.colors.inputFill,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 20.sp, color: context.colors.textSecondary),
              SizedBox(width: Insets.s8),
              Expanded(
                child: Text(
                  S.of(context).searchServiceHelp,
                  style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
