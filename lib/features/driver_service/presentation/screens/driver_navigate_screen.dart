import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_refueling_screen.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class DriverNavigateScreen extends StatefulWidget {
  final DriverNavigateArgs args;
  const DriverNavigateScreen({super.key, required this.args});

  @override
  State<DriverNavigateScreen> createState() => _DriverNavigateScreenState();
}

class _DriverNavigateScreenState extends State<DriverNavigateScreen> {
  // Default: Tripoli, Libya (not Riyadh)
  static const _defaultLat = 32.8872;
  static const _defaultLng = 13.1913;

  GoogleMapController? _mapController;
  Timer? _locationTimer;
  String _remainingDistance = '';

  // Provider's live position (updated every few seconds)
  LatLng? _providerPosition;

  // Cached map objects — only rebuilt when position actually changes
  Set<Marker> _cachedMarkers = {};
  Set<Polyline> _cachedPolylines = {};

  LatLng get _destination => LatLng(
        widget.args.lat ?? _defaultLat,
        widget.args.lng ?? _defaultLng,
      );

  bool get _isToCustomer => widget.args.navigationType == 'to_customer';

  String _title(BuildContext context) => _isToCustomer
      ? S.of(context).navigateToCustomer
      : S.of(context).navigateToDestination;

  String _locationLabel(BuildContext context) => _isToCustomer
      ? S.of(context).departurePoint
      : S.of(context).deliveryDestinationLabel;

  @override
  void initState() {
    super.initState();
    // Update status to en_route when navigating to customer
    final orderId = int.tryParse(widget.args.orderId);
    if (orderId != null && _isToCustomer) {
      sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'en_route'));
    }
    _rebuildMapObjects(); // show destination marker immediately
    _initLocation();
  }

  /// Get initial position then start periodic updates
  Future<void> _initLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _startLocationUpdates();
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      if (mounted) {
        _providerPosition = LatLng(pos.latitude, pos.longitude);
        _rebuildMapObjects();
        setState(() {});
        // Fit both markers on screen
        _fitBounds();
      }
    } catch (_) {}
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _sendCurrentLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _sendCurrentLocation();
    });
  }

  Future<void> _sendCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );

      // Send to API
      sl<ApiClient>().dio.patch('/provider/profile/location', data: {
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      });

      if (!mounted) {


        return;


      }

      final providerLatLng = LatLng(pos.latitude, pos.longitude);
      final km = _haversine(
        pos.latitude, pos.longitude,
        _destination.latitude, _destination.longitude,
      );

      _providerPosition = providerLatLng;
      _remainingDistance = '${km.toStringAsFixed(1)} ${S.of(context).kmUnit}';
      _rebuildMapObjects();
      setState(() {});

      // Smoothly move camera to follow provider
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(providerLatLng),
      );
    } catch (_) {}
  }

  double _haversine(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
        sin(dLng / 2) * sin(dLng / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  /// Fit camera to show both provider and destination markers
  void _fitBounds() {
    if (_providerPosition == null || _mapController == null) {

      return;

    }
    final bounds = LatLngBounds(
      southwest: LatLng(
        min(_providerPosition!.latitude, _destination.latitude),
        min(_providerPosition!.longitude, _destination.longitude),
      ),
      northeast: LatLng(
        max(_providerPosition!.latitude, _destination.latitude),
        max(_providerPosition!.longitude, _destination.longitude),
      ),
    );
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  /// Rebuild markers & polyline — called only when position changes
  void _rebuildMapObjects() {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: InfoWindow(
          title: _isToCustomer ? S.of(context).customerLocationMarker : S.of(context).deliveryPointMarker,
          snippet: widget.args.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    var polylines = <Polyline>{};

    if (_providerPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('provider'),
          position: _providerPosition!,
          infoWindow: InfoWindow(title: S.of(context).myLocationMarker),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      // Solid line — dash patterns cause memory leaks on iOS
      polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [_providerPosition!, _destination],
          color: context.colors.primary.withValues(alpha: 0.5),
          width: 3,
        ),
      };
    }

    _cachedMarkers = markers;
    _cachedPolylines = polylines;
  }

  Future<void> _moveToCurrentLocation() async {
    if (_providerPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_providerPosition!, 15),
      );
      return;
    }
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {

        return;

      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (!mounted) {

        return;

      }
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15),
      );
    } catch (_) {}
  }

  Future<void> _openInGoogleMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${_destination.latitude},${_destination.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onCancelOrder() async {
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

    if (widget.args.isFuel) {
      if (orderId != null) {
        sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'arrived'));
      }
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
      if (orderId != null) {
        sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'arrived'));
      }
      Navigator.pushReplacementNamed(
        context,
        Routes.driverDocumentation,
        arguments: DriverDocumentationArgs(
          orderId: widget.args.orderId,
          documentationType: _isToCustomer ? 'pickup' : 'delivery',
          amount: widget.args.amount,
          customerPhone: widget.args.customerPhone,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            // Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _destination,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                // Once map is ready, fit to show both points
                if (_providerPosition != null) {
                  Future.delayed(const Duration(milliseconds: 500), _fitBounds);
                }
              },
              markers: _cachedMarkers,
              polylines: _cachedPolylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              style: '[]', // Force light mode regardless of app theme
            ),

            // Header
            _buildHeader(context),

            // Side action buttons
            Positioned(
              left: Insets.s16,
              bottom: 280.h,
              child: Column(
                children: [
                  // Fit both markers
                  _buildSideButton(
                    icon: Icons.zoom_out_map_rounded,
                    onTap: _fitBounds,
                  ),
                  SizedBox(height: Insets.s8),
                  _buildSideButton(
                    icon: Icons.my_location_rounded,
                    onTap: _moveToCurrentLocation,
                  ),
                ],
              ),
            ),

            // Bottom panel
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomPanel(context),
            ),
          ],
        ),
    );
  }

  // ── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          color: context.colors.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    Insets.s16, Insets.s12, Insets.s16, Insets.s12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(backArrowIcon(context),
                          size: 24.sp, color: context.colors.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        _title(context),
                        style: getBoldStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 24.sp),
                  ],
                ),
              ),
              Divider(height: 1, color: context.colors.borderSubtle),
            ],
          ),
        ),
      );

  // ── Side action button ──────────────────────────────────────

  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: context.colors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow,
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22.sp, color: context.colors.primary),
        ),
      );

  // ── Bottom Panel ────────────────────────────────────────────

  Widget _buildBottomPanel(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.s24),
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 16.r,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(
          Insets.s16,
          Insets.s20,
          Insets.s16,
          Insets.s16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: Insets.s16),

            // Location info
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: context.colors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on_rounded,
                      size: 20.sp, color: context.colors.primary),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _locationLabel(context),
                        style: getRegularStyle(
                            color: context.colors.textSecondary,
                            fontSize: FontSize.s12),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.args.address,
                        style: getMediumStyle(
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Distance indicator
            if (_remainingDistance.isNotEmpty) ...[
              SizedBox(height: Insets.s12),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s12, vertical: Insets.s8),
                decoration: BoxDecoration(
                  color: context.colors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.straighten_rounded,
                        size: 18.sp, color: context.colors.primary),
                    SizedBox(width: 6.w),
                    Text('${S.of(context).remainingDistance} $_remainingDistance',
                        style: getMediumStyle(
                            color: context.colors.primary,
                            fontSize: FontSize.s14)),
                  ],
                ),
              ),
            ],
            SizedBox(height: Insets.s16),

            // Google Maps button + Call button
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: S.of(context).openInGoogleMaps,
                    isOutlined: true,
                    onPressed: _openInGoogleMaps,
                  ),
                ),
                SizedBox(width: Insets.s8),
                GestureDetector(
                  onTap: () {
                    final phone = widget.args.customerPhone;
                    if (phone != null && phone.isNotEmpty) {
                      launchUrl(Uri.parse('tel:$phone'));
                    }
                  },
                  child: Container(
                    width: Sizes.s48,
                    height: Sizes.s48,
                    decoration: BoxDecoration(
                      color: context.colors.primarySurface,
                      borderRadius:
                          BorderRadius.circular(AppRadius.s12),
                    ),
                    child: Icon(Icons.phone_rounded,
                        size: 22.sp, color: context.colors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.s12),

            // Arrived button
            AppButton(
              text: _isToCustomer && widget.args.isFuel
                  ? S.of(context).arrivedStartRefueling
                  : S.of(context).arrivedStartDoc,
              onPressed: _onArrivedTapped,
            ),
            SizedBox(height: Insets.s8),
            // Cancel order
            GestureDetector(
              onTap: _onCancelOrder,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.center,
                child: Text(
                  S.of(context).cancelOrderLabel,
                  style: getMediumStyle(
                    color: context.colors.error,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
