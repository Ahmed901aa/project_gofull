import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
          color: context.colors.surfaceVariant,
          border: Border.all(color: context.colors.border),
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
                color: context.colors.surface,
                child: Builder(builder: (ctx) {
                  final img = Image.asset(ImageAssets.offerBanner, fit: BoxFit.cover);
                  return Directionality.of(ctx) == TextDirection.rtl
                      ? Transform.scale(scaleX: -1, child: img)
                      : img;
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Insets.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: getSemiBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${S.of(context).useCodePrefix}${offer.code}',
                    style: getSemiBoldStyle(color: context.colors.primary, fontSize: FontSize.s14),
                    textAlign: TextAlign.start,
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
