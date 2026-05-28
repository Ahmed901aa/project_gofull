import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class MapSearchBar extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const MapSearchBar({
    super.key,
    required this.text,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Insets.s16, vertical: Insets.s12),
        height: 48.h,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          boxShadow: [
            BoxShadow(
                color: context.colors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: Insets.s12),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                color: context.colors.primary, size: 22.sp),
            SizedBox(width: Insets.s8),
            Expanded(
              child: Text(
                text.isEmpty ? l10n.searchHint : text,
                style: text.isEmpty
                    ? getRegularStyle(
                        color: context.colors.iconSecondary,
                        fontSize: FontSize.s14)
                    : getMediumStyle(
                        color: context.colors.textPrimary,
                        fontSize: FontSize.s14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child:
                    Icon(Icons.close, color: context.colors.iconSecondary, size: 18.sp),
              ),
          ],
        ),
      ),
    );
  }
}
