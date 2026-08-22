import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_refueling_screen.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/core/utils/tracked_dispatch.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_state.dart';

/// User actions triggered from the navigation screen: external maps, order
/// cancellation and the "arrived" transition.
mixin NavigateActionsMixin<T extends StatefulWidget> on State<T> {
  DriverNavigateArgs get navArgs;
  LatLng get destination;
  bool get isToCustomer;

  Future<void> openInGoogleMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void onArrivedTapped() {
    final orderId = int.tryParse(navArgs.orderId);
    // 'arrived' only applies while heading to the customer. On the towing
    // leg to the destination the order is already in_progress — re-sending
    // 'arrived' would move the status backwards (backend now rejects it).
    if (orderId != null && isToCustomer) {
      dispatchTracked<ProviderBloc, ProviderState>(
        sl<ProviderBloc>(),
        send: (b) =>
            b.add(UpdateStatusEvent(id: orderId, status: 'arrived')),
        isSuccess: (s) => s is StatusUpdated,
        isFailure: (s) => s is ProviderError,
        failureMessage: S.of(context).failedUpdateStatus,
      );
    }
    if (navArgs.isFuel) {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverRefueling,
        arguments: DriverRefuelingArgs(
          orderId: navArgs.orderId,
          amount: navArgs.amount,
          customerPhone: navArgs.customerPhone,
        ),
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverDocumentation,
        arguments: DriverDocumentationArgs(
          orderId: navArgs.orderId,
          documentationType: isToCustomer ? 'pickup' : 'delivery',
          amount: navArgs.amount,
          customerPhone: navArgs.customerPhone,
          destinationLat: navArgs.destinationLat,
          destinationLng: navArgs.destinationLng,
          destinationAddress: navArgs.destinationAddress,
        ),
      );
    }
  }
}
