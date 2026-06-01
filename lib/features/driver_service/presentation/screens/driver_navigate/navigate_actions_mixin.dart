import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_refueling_screen.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';

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

  Future<void> onCancelOrder() async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.cancel_rounded,
      iconColor: context.colors.error,
      title: S.of(context).cancelOrderDialogTitle,
      subtitle: S.of(context).cancelOrderDialogSubtitle,
      confirmLabel: S.of(context).cancelOrderDialogBtn,
      cancelLabel: S.of(context).cancelOrderDialogGoBack,
      destructive: true,
    );
    if (confirmed) {
      final orderId = int.tryParse(navArgs.orderId);
      if (orderId != null) {
        sl<ProviderBloc>().add(CancelOrderEvent(id: orderId));
      }
      if (mounted) Navigator.pop(context);
    }
  }

  void onArrivedTapped() {
    final orderId = int.tryParse(navArgs.orderId);
    if (orderId != null) {
      sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'arrived'));
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
