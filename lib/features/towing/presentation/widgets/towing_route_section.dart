import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/cubits/location_state.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/service_location_card.dart';

class TowingRouteSection extends StatelessWidget {
  final String destinationAddress;
  final VoidCallback onDestinationTap;

  const TowingRouteSection({
    super.key,
    required this.destinationAddress,
    required this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<LocationCubit, LocationState>(
            builder: (context, loc) => ServiceLocationCard(
              topLabel: 'نقطة الانطلاق',
              bottomLabel: loc.address,
              onTap: () => Navigator.pushNamed(context, Routes.locationPicker),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ServiceLocationCard(
            topLabel: 'وجهة التوصيل',
            bottomLabel: destinationAddress,
            onTap: onDestinationTap,
          ),
        ),
      ],
    );
  }
}
