part of '../driver_navigate_screen.dart';

/// User actions triggered from the navigation screen: external maps, order
/// cancellation and the "arrived" transition.
extension _NavigateActions on _DriverNavigateScreenState {
  Future<void> _openInGoogleMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${_destination.latitude},${_destination.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _onCancelOrder() async {
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
      final orderId = int.tryParse(widget.args.orderId);
      if (orderId != null) {
        sl<ProviderBloc>().add(CancelOrderEvent(id: orderId));
      }
      if (mounted) Navigator.pop(context);
    }
  }

  void _onArrivedTapped() {
    final orderId = int.tryParse(widget.args.orderId);
    if (orderId != null) {
      sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'arrived'));
    }
    if (widget.args.isFuel) {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverRefueling,
        arguments: DriverRefuelingArgs(
          orderId: widget.args.orderId,
          amount: widget.args.amount,
          customerPhone: widget.args.customerPhone,
        ),
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverDocumentation,
        arguments: DriverDocumentationArgs(
          orderId: widget.args.orderId,
          documentationType: _isToCustomer ? 'pickup' : 'delivery',
          amount: widget.args.amount,
          customerPhone: widget.args.customerPhone,
          destinationLat: widget.args.destinationLat,
          destinationLng: widget.args.destinationLng,
          destinationAddress: widget.args.destinationAddress,
        ),
      );
    }
  }
}
