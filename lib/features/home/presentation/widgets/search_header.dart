import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  const SearchHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: context.colors.textPrimary),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Container(
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
                          child: TextField(
                            controller: controller,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: S.of(context).searchServiceHelp,
                              hintStyle: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
                          ),
                        ),
                        if (controller.text.isNotEmpty)
                          GestureDetector(
                            onTap: () => controller.clear(),
                            child: Icon(Icons.close_rounded, size: 18.sp, color: context.colors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ],
      ),
    );
  }
}
