import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.colors.primary, context.colors.primaryLight],
        ),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(AppRadius.s24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                Insets.s16, Insets.s8, Insets.s16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${S.of(context).welcomePrefix} $userName',
                        style: getBoldStyle(
                          color: context.colors.surface,
                          fontSize: FontSize.s20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        S.of(context).welcomeSubtitle,
                        style: getRegularStyle(
                          color: context.colors.surface.withValues(alpha: 0.85),
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
                _NotificationBell(
                  onTap: () =>
                      Navigator.pushNamed(context, '/notifications'),
                ),
              ],
            ),
          ),
          SizedBox(height: Insets.s12),
          HomeSearchBar(onTap: onSearchTap),
        ],
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
        radius: 24.w,
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1,
            ),
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
                  width: 8.w,
                  height: 8.w,
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
