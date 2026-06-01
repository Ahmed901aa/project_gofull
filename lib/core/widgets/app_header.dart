import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = true,
  });

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
                if (showBack)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(backArrowIcon(context), size: 24.sp, color: context.colors.textPrimary),
                  )
                else
                  SizedBox(width: 24.sp),
                Expanded(
                  child: Text(
                    title,
                    style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 24.sp),
              ],
            ),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ],
      ),
    );
  }
}
