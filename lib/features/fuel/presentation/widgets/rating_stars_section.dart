import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class RatingStarsSection extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  const RatingStarsSection({super.key, required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.howWasYourExperience, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        SizedBox(height: 2.h),
        Text(
          l10n.feedbackHelpsImprove,
          style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s16),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => onRatingChanged(star),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    rating >= star ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 40.sp,
                    color: const Color(0xFFFFB800),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
