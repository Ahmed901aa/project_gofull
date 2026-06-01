import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ProfileUserCard extends StatelessWidget {
  final String name;
  final String phone;
  final String initials;

  /// Tap handler for the "View" pill on the right side of the card.
  /// Renamed from `onEdit` to reflect the read-only profile screen.
  final VoidCallback? onView;

  const ProfileUserCard({
    super.key,
    required this.name,
    required this.phone,
    required this.initials,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [context.colors.primary, context.colors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s24),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.s24),
        child: Stack(
          children: [
            // Decorative halos
            PositionedDirectional(
              end: -30.w,
              top: -20.h,
              child: _Halo(
                size: 130.w,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            PositionedDirectional(
              start: -20.w,
              bottom: -30.h,
              child: _Halo(
                size: 90.w,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),

            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: Insets.s16,
                vertical: Insets.s16,
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [
                          Colors.white.withValues(alpha: 0.30),
                          Colors.white.withValues(alpha: 0.15),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.40),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials.toUpperCase(),
                      style: getBoldStyle(
                        color: Colors.white,
                        fontSize: FontSize.s20,
                      ),
                    ),
                  ),
                  SizedBox(width: Insets.s12),
                  // Name + phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: FontSize.s18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          phone,
                          style: getRegularStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: FontSize.s12,
                          ),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // "View" chip
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onView,
                      borderRadius: BorderRadius.circular(AppRadius.s24),
                      child: Container(
                        height: 34.h,
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: Insets.s14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppRadius.s24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 14.sp,
                              color: context.colors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              S.of(context).view,
                              style: getBoldStyle(
                                color: context.colors.primary,
                                fontSize: FontSize.s13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Halo extends StatelessWidget {
  final double size;
  final Color color;
  const _Halo({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
