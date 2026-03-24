import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class PromoBannerCard extends StatelessWidget {
  const PromoBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.95, 0.35),
          end: Alignment(0.95, -0.35),
          colors: [Color(0xFFFFB800), Color(0xFFE1A200), Color(0xFF996E00)],
          stops: [0.048, 0.307, 1.0],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10.w, top: 8.h,
            child: Container(
              width: 108.w, height: 124.h,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFCF40).withValues(alpha: 0.4)),
            ),
          ),
          Positioned(
            right: -10.w, top: 8.h,
            child: Container(
              width: 108.w, height: 124.h,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFB88A00).withValues(alpha: 0.25)),
            ),
          ),
          Positioned(
            right: -10.w, top: -5.h, bottom: -5.h, width: 140.w,
            child: Transform.scale(
              scaleX: -1,
              child: Image.asset(ImageAssets.promoTruck, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s12, 0, 140.w, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    textDirection: TextDirection.rtl,
                    text: TextSpan(
                      style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                      children: const [
                        TextSpan(text: 'جميع  خدمات الطوارئ في '),
                        TextSpan(text: 'اشتراك واحد', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: Insets.s8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppRadius.s24)),
                    child: Text('قسائم مجانية + خصومات حصرية', style: getMediumStyle(color: AppColors.primary, fontSize: FontSize.s12)),
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
