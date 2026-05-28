import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class OffersShimmer extends StatelessWidget {
  const OffersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.s40 * 4,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: Insets.s12),
        itemBuilder: (_, __) => Container(
          width: 220.w,
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
        ),
      ),
    );
  }
}
