import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverFoundHeader extends StatelessWidget {
  final bool showClose;

  const DriverFoundHeader({super.key, required this.showClose});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showClose)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close_rounded, size: 24.sp, color: context.colors.textPrimary),
                  )
                else
                  const SizedBox(width: 24),
                Text(S.of(context).onTheWayToYou, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20)),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: context.colors.textPrimary),
              ],
            ),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ],
      ),
    );
  }
}
