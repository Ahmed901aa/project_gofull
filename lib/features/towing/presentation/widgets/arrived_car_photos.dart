import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ArrivedCarPhotos extends StatelessWidget {
  const ArrivedCarPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('صور السيارة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
        SizedBox(height: Insets.s8),
        Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i < 2 ? Insets.s8 : 0),
                child: const _PhotoPlaceholder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Icon(Icons.image_outlined, size: 28.sp, color: AppColors.neutral600),
    );
  }
}
