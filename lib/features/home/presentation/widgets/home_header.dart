import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'home_location_bar.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onSearchTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.colors.primary, context.colors.primaryLight],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.s32),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.s32),
        ),
        child: Stack(
          children: [
            // ── Decorative background shapes ──
            PositionedDirectional(
              end: -50.w,
              top: topPadding - 20.h,
              child: _Halo(
                size: 180.w,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            PositionedDirectional(
              end: 30.w,
              top: topPadding + 30.h,
              child: _Halo(
                size: 90.w,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            PositionedDirectional(
              start: -40.w,
              bottom: -30.h,
              child: _Halo(
                size: 140.w,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),

            // ── Content ──
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: topPadding),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    Insets.s16,
                    Insets.s12,
                    Insets.s16,
                    0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _Avatar(name: userName),
                      SizedBox(width: Insets.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${S.of(context).welcomePrefix} $userName',
                              style: getBoldStyle(
                                color: context.colors.surface,
                                fontSize: FontSize.s18,
                              ).copyWith(letterSpacing: 0.2),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Container(
                                  width: 7.w,
                                  height: 7.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF66FFB3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x6666FFB3),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Flexible(
                                  child: Text(
                                    S.of(context).welcomeSubtitle,
                                    style: getRegularStyle(
                                      color: context.colors.surface
                                          .withValues(alpha: 0.90),
                                      fontSize: FontSize.s12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Insets.s8),
                      _NotificationBell(
                        onTap: () =>
                            Navigator.pushNamed(context, '/notifications'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Insets.s16),
                HomeSearchBar(onTap: onSearchTap),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small circular avatar that shows the first letter of the user's name.
/// Falls back to a person icon if the name is empty.
class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim().characters.first : '';
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            Colors.white.withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0.15),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.40),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: initial.isNotEmpty
          ? Text(
              initial,
              style: getBoldStyle(
                color: context.colors.surface,
                fontSize: FontSize.s18,
              ),
            )
          : Icon(
              Icons.person_rounded,
              color: context.colors.surface,
              size: 22.sp,
            ),
    );
  }
}

/// Bell icon button with a small "unread" badge dot in the top-end corner.
class _NotificationBell extends StatelessWidget {
  final VoidCallback onTap;
  const _NotificationBell({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 26.w,
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                Colors.white.withValues(alpha: 0.28),
                Colors.white.withValues(alpha: 0.15),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.40),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: context.colors.surface,
                size: 22.sp,
              ),
              PositionedDirectional(
                top: 10.w,
                end: 10.w,
                child: Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
