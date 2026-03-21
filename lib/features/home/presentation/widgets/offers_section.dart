import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';

class OffersSection extends StatelessWidget {
  final List<OfferEntity> offers;
  const OffersSection({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: offers.length,
        separatorBuilder: (_, __) => SizedBox(width: Insets.s12),
        itemBuilder: (context, index) => _OfferCard(offer: offers[index]),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final OfferEntity offer;
  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    final color = Color(offer.colorValue);
    return Container(
      width: 220.w,
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 70.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/Frame 1984080691.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: Sizes.s8),
          Text(
            offer.title,
            style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                AppStrings.useCode,
                style: getRegularStyle(color: AppColors.grey, fontSize: 11.sp),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8, vertical: 2.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  offer.code,
                  style: getBoldStyle(color: color, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
