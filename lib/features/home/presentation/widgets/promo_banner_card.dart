import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/features/home/presentation/widgets/banner_data.dart';

class PromoBannerCard extends StatelessWidget {
  final int index;
  final VoidCallback? onTap;
  const PromoBannerCard({super.key, required this.index, this.onTap});

  @override
  Widget build(BuildContext context) {
    final slides = getBannerSlides(context);
    final slide = slides[index % slides.length];
    final accentColor = index == 0 ? AppColors.white : const Color(0xFFFFE082);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s20),
        splashColor: Colors.white.withValues(alpha: 0.10),
        highlightColor: Colors.white.withValues(alpha: 0.05),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(-0.95, 0.45),
              end: const Alignment(0.95, -0.45),
              colors: slide.gradientColors,
            ),
            borderRadius: BorderRadius.circular(AppRadius.s20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s20),
            child: Stack(
              children: [
                // ── Decorative layered halos ────────────────────────
                PositionedDirectional(
                  end: -36.w,
                  top: -36.h,
                  child: _Halo(
                    size: 170.w,
                    color: Colors.white.withValues(alpha: 0.09),
                  ),
                ),
                PositionedDirectional(
                  end: 18.w,
                  top: 24.h,
                  child: _Halo(
                    size: 90.w,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                PositionedDirectional(
                  start: -28.w,
                  bottom: -28.h,
                  child: _Halo(
                    size: 130.w,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                // Subtle bottom shine
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.20),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Content ─────────────────────────────────────────
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    Insets.s16,
                    Insets.s14,
                    Insets.s12,
                    Insets.s14,
                  ),
                  child: Row(
                    children: [
                      // Text column
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tag pill with leading icon
                            Container(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                Insets.s8,
                                4.h,
                                Insets.s10,
                                4.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.white.withValues(alpha: 0.22),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.s20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.30),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(slide.icon,
                                      size: 12.sp, color: Colors.white),
                                  SizedBox(width: 4.w),
                                  Text(
                                    slide.tag,
                                    style: getSemiBoldStyle(
                                      color: AppColors.white,
                                      fontSize: FontSize.s11,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Headline
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: getBoldStyle(
                                  color: AppColors.white,
                                  fontSize: FontSize.s16,
                                ).copyWith(height: 1.25),
                                children: [
                                  TextSpan(text: slide.headline),
                                  TextSpan(
                                    text: slide.headlineAccent,
                                    style: TextStyle(
                                      color: accentColor,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.18),
                                          blurRadius: 6,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // CTA row: badge pill + arrow chip
                            Row(
                              children: [
                                // Badge pill (code / value)
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: Insets.s10,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.s24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.10),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      slide.badge,
                                      style: getBoldStyle(
                                        color: slide.gradientColors.last,
                                        fontSize: FontSize.s11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                // Round arrow chip
                                Container(
                                  width: 26.w,
                                  height: 26.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withValues(alpha: 0.22),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.35),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Icon(
                                    forwardArrowIcon(context),
                                    size: 14.sp,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: Insets.s8),

                      // Image
                      SizedBox(
                        width: 120.w,
                        child: Builder(builder: (ctx) {
                          final img = Image.asset(
                            slide.image,
                            fit: BoxFit.contain,
                          );
                          final isRtl =
                              Directionality.of(ctx) == TextDirection.rtl;
                          return (slide.flipImageInRtl && isRtl)
                              ? Transform.scale(scaleX: -1, child: img)
                              : img;
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
