import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_map_state_mixin.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_location_mixin.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_actions_mixin.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_map.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_header.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_side_buttons.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_bottom_panel.dart';

class DriverNavigateScreen extends StatefulWidget {
  final DriverNavigateArgs args;
  const DriverNavigateScreen({super.key, required this.args});

  @override
  State<DriverNavigateScreen> createState() => _DriverNavigateScreenState();
}

class _DriverNavigateScreenState extends State<DriverNavigateScreen>
    with
        NavigateMapStateMixin<DriverNavigateScreen>,
        NavigateLocationMixin<DriverNavigateScreen>,
        NavigateActionsMixin<DriverNavigateScreen> {
  @override
  DriverNavigateArgs get navArgs => widget.args;

  @override
  void initState() {
    super.initState();
    final orderId = int.tryParse(widget.args.orderId);
    if (orderId != null && isToCustomer) {
      sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'en_route'));
    }
    initLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Build markers once dependencies (Localizations, Theme) are ready.
    rebuildMapObjects();
  }

  @override
  void dispose() {
    disposeLocation();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (providerPosition != null) {
      Future.delayed(const Duration(milliseconds: 500), fitBounds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NavigateMap(
            destination: destination,
            markers: markers,
            polylines: polylines,
            onMapCreated: _onMapCreated,
          ),
          NavigateHeader(isToCustomer: isToCustomer, onBack: () => Navigator.pop(context)),
          PositionedDirectional(
            start: Insets.s16,
            bottom: 280.h,
            child: NavigateSideButtons(onFit: fitBounds, onMyLocation: moveToCurrentLocation),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigateBottomPanel(
              isToCustomer: isToCustomer,
              isFuel: widget.args.isFuel,
              address: widget.args.address,
              remainingDistance: remainingDistance,
              customerPhone: widget.args.customerPhone,
              onOpenMaps: openInGoogleMaps,
              onArrived: onArrivedTapped,
              onCancel: onCancelOrder,
            ),
          ),
        ],
      ),
    );
  }
}
