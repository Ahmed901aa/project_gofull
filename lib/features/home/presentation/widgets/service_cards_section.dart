import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'service_card.dart';

class ServiceCardsSection extends StatelessWidget {
  const ServiceCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: Sizes.s12),
          child: Row(
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
              Text(
                l10n.ourServices,
                style: getBoldStyle(
                  color: context.colors.textPrimary,
                  fontSize: FontSize.s18,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ServiceCard(
                svgAsset: IconAssets.fuelTruck,
                title: l10n.fuelSupply,
                subtitle: l10n.fuelSupplyDesc,
                flipIcon: true,
                onTap: () => Navigator.pushNamed(context, Routes.fuelType),
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: ServiceCard(
                svgAsset: IconAssets.towTruck,
                title: l10n.towTruckService,
                subtitle: l10n.towTruckServiceDesc,
                flipIcon: true,
                onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
