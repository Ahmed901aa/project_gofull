import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/presentation/widgets/banner_data.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PromoBannerCard extends StatelessWidget {
  final int index;
  const PromoBannerCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final slides = getBannerSlides(context);
    final slide = slides[index % slides.length];
    final accentColor = index == 0 ? AppColors.white : const Color(0xFFFFD54F);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.95, 0.35),
          end: const Alignment(0.95, -0.35),
          colors: slide.gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // ── Decorative circles (background only) ──
          PositionedDirectional(
            end: -20.w,
            top: -16.h,
            child: Container(
              width: 130.w,
              height: 130.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          PositionedDirectional(
            end: 10.w,
            top: 20.h,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // ── Content: Row(text | image) ──
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              Insets.s16, Insets.s12, Insets.s8, Insets.s12,
            ),
            child: Row(
              children: [
                // Text column — takes remaining space
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.s8,
                          vertical: Sizes.s4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.s20),
                        ),
                        child: Text(
                          slide.tag,
                          style: getMediumStyle(
                            color: AppColors.white,
                            fontSize: FontSize.s11,
                          ),
                        ),
                      ),
                      SizedBox(height: Sizes.s4),

                      // Headline
                      RichText(
                        text: TextSpan(
                          style: getBoldStyle(
                            color: AppColors.white,
                            fontSize: FontSize.s15,
                          ),
                          children: [
                            TextSpan(text: slide.headline),
                            TextSpan(
                              text: slide.headlineAccent,
                              style: TextStyle(color: accentColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Sizes.s4),

                      // Badge pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.s10,
                          vertical: Sizes.s4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.s24),
                        ),
                        child: Text(
                          slide.badge,
                          style: getSemiBoldStyle(
                            color: slide.gradientColors.last,
                            fontSize: FontSize.s11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: Insets.s8),

                // Image — fixed width, vertically centered by Row
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
    );
  }
}
