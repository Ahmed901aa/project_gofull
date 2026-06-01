import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color? iconColor;
  final VoidCallback? onTap;

  /// If `true`, the icon container uses an error tint (for destructive
  /// actions like logout).
  final bool destructive;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.iconColor,
    this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = destructive
        ? context.colors.error
        : (iconColor ?? context.colors.primary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        splashColor: accent.withValues(alpha: 0.10),
        highlightColor: accent.withValues(alpha: 0.04),
        child: Container(
          height: 56.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s14),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              // Tinted icon container
              Container(
                width: 36.w,
                height: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                ),
                child: Icon(icon, size: 18.sp, color: accent),
              ),
              SizedBox(width: Insets.s12),
              // Label
              Expanded(
                child: Text(
                  label,
                  style: getMediumStyle(
                    color: destructive
                        ? context.colors.error
                        : context.colors.textPrimary,
                    fontSize: FontSize.s15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: Insets.s8),
                Text(
                  trailing!,
                  style: getRegularStyle(
                    color: context.colors.textSecondary,
                    fontSize: FontSize.s13,
                  ),
                ),
                SizedBox(width: 6.w),
              ],
              Icon(
                forwardChevronIcon(context),
                size: 14.sp,
                color: context.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
