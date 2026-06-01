import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Numbered card used to render a section of a legal document
/// (privacy policy, terms & conditions).
class LegalSectionCard extends StatelessWidget {
  final int number;
  final IconData icon;
  final String title;
  final String body;

  const LegalSectionCard({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(Insets.s14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s20),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row: numbered badge + icon + title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Numbered badge
              Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      context.colors.primary,
                      context.colors.primaryLight,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          context.colors.primary.withValues(alpha: 0.30),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$number',
                  style: getBoldStyle(
                    color: Colors.white,
                    fontSize: FontSize.s13,
                  ),
                ),
              ),
              SizedBox(width: Insets.s10),

              // Icon
              Icon(icon, size: 18.sp, color: context.colors.primary),
              SizedBox(width: 6.w),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: getBoldStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Sizes.s8),

          // Subtle divider
          Container(
            height: 1,
            color: context.colors.primary.withValues(alpha: 0.08),
          ),
          SizedBox(height: Sizes.s8),

          // Body
          Text(
            body,
            style: getRegularStyle(
              color: context.colors.textSecondary,
              fontSize: FontSize.s13,
            ).copyWith(height: 1.7),
          ),
        ],
      ),
    );
  }
}
