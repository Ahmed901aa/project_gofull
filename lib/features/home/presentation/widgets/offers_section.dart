import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';
import 'offer_card.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class OffersSection extends StatelessWidget {
  final List<OfferEntity> offers;
  const OffersSection({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: Insets.s8),
              Expanded(
                child: Text(
                  l10n.offersForYou,
                  style: getBoldStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s18,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, Routes.discountCodes),
                borderRadius: BorderRadius.circular(AppRadius.s8),
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: Insets.s8,
                    vertical: 4.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.seeAll,
                        style: getMediumStyle(
                          color: context.colors.primary,
                          fontSize: FontSize.s13,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        forwardChevronIcon(context),
                        size: 14.sp,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Sizes.s12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (int i = 0; i < offers.length; i++) ...[
                if (i > 0) SizedBox(width: Insets.s12),
                OfferCard(offer: offers[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
