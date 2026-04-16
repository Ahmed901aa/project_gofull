import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
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
            title: AppStrings.fuelSupply,
            subtitle: AppStrings.fuelSupplyDesc,
            flipIcon: true,
            onTap: () => Navigator.pushNamed(context, Routes.fuelType),
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: ServiceCard(
            svgAsset: IconAssets.towTruck,
            title: AppStrings.towTruckService,
            subtitle: AppStrings.towTruckServiceDesc,
            flipIcon: true,
            onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
          ),
        ),
      ],
    );
  }
}
