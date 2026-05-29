import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_refueling_screen.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_geo.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate/navigate_map_objects.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_map.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_header.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_side_buttons.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_bottom_panel.dart';

part 'driver_navigate/navigate_location.dart';
part 'driver_navigate/navigate_actions.dart';

// Default map center: Tripoli, Libya.
const _defaultLat = 32.8872;
const _defaultLng = 13.1913;

class DriverNavigateScreen extends StatefulWidget {
  final DriverNavigateArgs args;
  const DriverNavigateScreen({super.key, required this.args});

  @override
  State<DriverNavigateScreen> createState() => _DriverNavigateScreenState();
}

class _DriverNavigateScreenState extends State<DriverNavigateScreen> {
  GoogleMapController? _mapController;
  Timer? _locationTimer;
  String _remainingDistance = '';
  LatLng? _providerPosition;
  Set<Marker> _cachedMarkers = {};
  Set<Polyline> _cachedPolylines = {};

  @override
  void initState() {
    super.initState();
    final orderId = int.tryParse(widget.args.orderId);
    if (orderId != null && _isToCustomer) {
      sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'en_route'));
    }
    _initLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Build markers once dependencies (Localizations, Theme) are ready.
    _rebuildMapObjects();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NavigateMap(
            destination: _destination,
            markers: _cachedMarkers,
            polylines: _cachedPolylines,
            onMapCreated: (controller) {
              _mapController = controller;
              if (_providerPosition != null) {
                Future.delayed(const Duration(milliseconds: 500), _fitBounds);
              }
            },
          ),
          NavigateHeader(isToCustomer: _isToCustomer, onBack: () => Navigator.pop(context)),
          PositionedDirectional(
            start: Insets.s16,
            bottom: 280.h,
            child: NavigateSideButtons(onFit: _fitBounds, onMyLocation: _moveToCurrentLocation),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigateBottomPanel(
              isToCustomer: _isToCustomer,
              isFuel: widget.args.isFuel,
              address: widget.args.address,
              remainingDistance: _remainingDistance,
              customerPhone: widget.args.customerPhone,
              onOpenMaps: _openInGoogleMaps,
              onArrived: _onArrivedTapped,
              onCancel: _onCancelOrder,
            ),
          ),
        ],
      ),
    );
  }
}
