import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class SearchResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String category;
  final String? highlightQuery;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.onTap,
    this.highlightQuery,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Insets.s12),
        margin: EdgeInsets.only(bottom: Insets.s8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Icon(icon, size: 22.sp, color: context.colors.primary),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTitle(context)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.s24),
                        ),
                        child: Text(
                          category,
                          style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14),
                  ),
                ],
              ),
            ),
            SizedBox(width: Insets.s8),
            Icon(Icons.arrow_back_rounded, size: 12.sp, color: context.colors.border),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (highlightQuery == null || highlightQuery!.isEmpty || !title.contains(highlightQuery!)) {
      return Text(title, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s16));
    }
    final idx = title.indexOf(highlightQuery!);
    final before = title.substring(0, idx);
    final match = title.substring(idx, idx + highlightQuery!.length);
    final after = title.substring(idx + highlightQuery!.length);
    return RichText(
      text: TextSpan(
        style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s16),
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          TextSpan(text: match, style: getBoldStyle(color: context.colors.primary, fontSize: FontSize.s16)),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
    );
  }
}
