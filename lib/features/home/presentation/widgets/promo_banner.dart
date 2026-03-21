import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6B5A10),
            Color(0xFFAA9628),
            Color(0xFFB8A530),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Ellipse truck SVG on the right (RTL: visually left)
          Positioned(
            right: -5.w,
            top: -5.h,
            bottom: -5.h,
            child: SvgPicture.asset(
              'assets/svg/Ellipse 208 (1).svg',
              height: 140.h,
              fit: BoxFit.contain,
            ),
          ),

          // Text content
          Padding(
            padding: EdgeInsets.fromLTRB(
              Insets.s16,
              Insets.s20,
              Insets.s16,
              Insets.s20,
            ),
            child: Row(
              children: [
                // Text on the right side (RTL: visually right)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.subscriptionTitle,
                        style: getBoldStyle(
                          color: AppColors.white,
                          fontSize: FontSize.s16,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: Sizes.s12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.s12,
                          vertical: Insets.s4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.s24),
                        ),
                        child: Text(
                          AppStrings.subscriptionSubtitle,
                          style: getSemiBoldStyle(
                            color: const Color(0xFF6B5A10),
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Space for the ellipse
                SizedBox(width: 100.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
