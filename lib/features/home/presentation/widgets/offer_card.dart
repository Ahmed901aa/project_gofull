import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';

class OfferCard extends StatelessWidget {
  final OfferEntity offer;
  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.s16),
      child: Container(
        width: 272.w,
        decoration: BoxDecoration(
          color: AppColors.neutral300,
          border: Border.all(color: AppColors.neutral500),
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRect(
              child: Container(
                height: 120.h,
                width: double.infinity,
                color: Colors.white,
                child: Image.asset(ImageAssets.offerBanner, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Insets.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: getSemiBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'استخدم كود: ${offer.code}',
                    style: getSemiBoldStyle(color: AppColors.primary, fontSize: FontSize.s14),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
