import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'banner_data.dart';

class PromoBannerCard extends StatelessWidget {
  final int index;
  const PromoBannerCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final slide = bannerSlides[index % bannerSlides.length];
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
        clipBehavior: Clip.none,
        children: [
          Positioned(right: -20.w, top: -16.h, child: Container(width: 130.w, height: 130.w, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)))),
          Positioned(right: 10.w, top: 20.h, child: Container(width: 80.w, height: 80.w, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
          Positioned(
            right: -10.w, top: -5.h, bottom: -5.h, width: 140.w,
            child: Transform.scale(scaleX: -1, child: Image.asset(ImageAssets.promoTruck, fit: BoxFit.contain)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s12, 0, 140.w, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20.r)),
                    child: Text(slide.tag, style: getMediumStyle(color: AppColors.white, fontSize: FontSize.s12)),
                  ),
                  SizedBox(height: 6.h),
                  RichText(
                    textDirection: TextDirection.rtl,
                    text: TextSpan(
                      style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                      children: [
                        TextSpan(text: slide.headline),
                        TextSpan(text: slide.headlineAccent, style: TextStyle(color: accentColor)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppRadius.s24)),
                    child: Text(slide.badge, style: getMediumStyle(color: slide.gradientColors.last, fontSize: FontSize.s12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
