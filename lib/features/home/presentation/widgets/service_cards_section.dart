import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'service_card.dart';

class ServiceCardsSection extends StatelessWidget {
  const ServiceCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ServiceCard(
            svgAsset: IconAssets.fuelTruck,
            title: S.of(context).fuelSupply,
            subtitle: S.of(context).fuelSupplyDesc,
            flipIcon: true,
            onTap: () => Navigator.pushNamed(context, Routes.fuelType),
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: ServiceCard(
            svgAsset: IconAssets.towTruck,
            title: S.of(context).towTruckService,
            subtitle: S.of(context).towTruckServiceDesc,
            flipIcon: true,
            onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
          ),
        ),
      ],
    );
  }
}
