import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';
import 'offer_card.dart';

class OffersSection extends StatelessWidget {
  final List<OfferEntity> offers;
  const OffersSection({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              S.of(context).offersForYou,
              style: getSemiBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        SizedBox(height: Sizes.s12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (int i = 0; i < offers.length; i++) ...[
                if (i > 0) SizedBox(width: Insets.s16),
                OfferCard(offer: offers[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
