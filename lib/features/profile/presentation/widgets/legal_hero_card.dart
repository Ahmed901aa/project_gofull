import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Hero card shown at the top of legal screens (Privacy Policy, Terms).
/// Soft brand-tinted gradient background, large icon medallion, title,
/// and a "Last updated" pill.
class LegalHeroCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String lastUpdated;

  const LegalHeroCard({
    super.key,
    required this.icon,
    required this.title,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Insets.s20,
        vertical: Insets.s20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            context.colors.primary,
            context.colors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s24),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon medallion
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      Colors.white.withValues(alpha: 0.30),
                      Colors.white.withValues(alpha: 0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.40),
                    width: 1.2,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 28.sp),
              ),
              SizedBox(height: Sizes.s12),

              // Title
              Text(
                title,
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: FontSize.s20,
                ).copyWith(letterSpacing: 0.2),
              ),
              SizedBox(height: Sizes.s8),

              // Last updated pill
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: Insets.s12,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(AppRadius.s32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.30),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 12.sp, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      lastUpdated,
                      style: getMediumStyle(
                        color: Colors.white,
                        fontSize: FontSize.s11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
