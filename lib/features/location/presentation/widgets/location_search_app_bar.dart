import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Header: [X close] ←title→ [search icon]
/// RTL Row: first child = rightmost, last child = leftmost.
class LocationSearchAppBar extends StatelessWidget {
  final VoidCallback onClose;
  const LocationSearchAppBar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, 4.h, Insets.s16, 12.h),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // RTL: first child → rightmost = X button
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Icon(Icons.close, size: 24.sp, color: context.colors.textPrimary),
          ),
          Text(
            S.of(context).currentLocation,
            style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20),
          ),
          // RTL: last child → leftmost = search icon (decorative)
          Icon(Icons.search_rounded, size: 24.sp, color: context.colors.textPrimary),
        ],
      ),
    );
  }
}
