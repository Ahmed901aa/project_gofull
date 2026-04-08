import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_refueling_screen.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverNavigateScreen extends StatefulWidget {
  final DriverNavigateArgs args;
  const DriverNavigateScreen({super.key, required this.args});

  @override
  State<DriverNavigateScreen> createState() => _DriverNavigateScreenState();
}

class _DriverNavigateScreenState extends State<DriverNavigateScreen> {
  static const _defaultLat = 24.7136;
  static const _defaultLng = 46.6753;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Timer? _locationTimer;
  String _remainingDistance = '';

  LatLng get _destination => LatLng(
        widget.args.lat ?? _defaultLat,
        widget.args.lng ?? _defaultLng,
      );

  bool get _isToCustomer => widget.args.navigationType == 'to_customer';

  String get _title => _isToCustomer
      ? AppStrings.navigateToCustomer
      : AppStrings.navigateToDestination;

  String get _locationLabel => _isToCustomer
      ? AppStrings.departurePoint
      : AppStrings.deliveryDestinationLabel;

  @override
  void initState() {
    super.initState();
    _setupMarkers();
    // Update status to en_route when navigating to customer
    final orderId = int.tryParse(widget.args.orderId);
    if (orderId != null && _isToCustomer) {
      sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'en_route'));
    }
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _sendCurrentLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _sendCurrentLocation();
    });
  }

  Future<void> _sendCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
      sl<ApiClient>().dio.patch('/provider/profile/location', data: {
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      });
      // Update remaining distance
      if (mounted) {
        final km = _haversine(pos.latitude, pos.longitude,
            _destination.latitude, _destination.longitude);
        setState(() => _remainingDistance = '${km.toStringAsFixed(1)} كم');
      }
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

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _setupMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        infoWindow: InfoWindow(title: widget.args.address),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
    };
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      if (!mounted) return;
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(pos.latitude, pos.longitude), 15),
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

  void _onArrivedTapped() {
    final orderId = int.tryParse(widget.args.orderId);

    if (widget.args.isFuel) {
      // Fuel delivery: go to refueling screen
      if (orderId != null) {
        sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'arrived'));
      }
      Navigator.pushReplacementNamed(
        context,
        Routes.driverRefueling,
        arguments: DriverRefuelingArgs(
          orderId: widget.args.orderId,
          amount: widget.args.amount,
        ),
      );
    } else {
      // Towing: go to documentation
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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
              },
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),

            // Header
            _buildHeader(context),

            // Side action buttons (refresh + my location)
            Positioned(
              left: Insets.s16,
              bottom: 280.h,
              child: Column(
                children: [
                  _buildSideButton(
                    icon: Icons.refresh_rounded,
                    onTap: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(_destination, 14),
                      );
                    },
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
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          color: AppColors.white,
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
                      child: Icon(Icons.arrow_back_rounded,
                          size: 24.sp, color: const Color(0xFF0E0E0E)),
                    ),
                    Expanded(
                      child: Text(
                        _title,
                        style: getBoldStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 24.sp),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
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
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22.sp, color: AppColors.primary),
        ),
      );

  // ── Bottom Panel ────────────────────────────────────────────

  Widget _buildBottomPanel(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.s24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
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
                  color: AppColors.neutral600,
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
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on_rounded,
                      size: 20.sp, color: AppColors.primary),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _locationLabel,
                        style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s12),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.args.address,
                        style: getMediumStyle(
                            color: const Color(0xFF0E0E0E),
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
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.straighten_rounded,
                        size: 18.sp, color: AppColors.primary),
                    SizedBox(width: 6.w),
                    Text('المسافة المتبقية: $_remainingDistance',
                        style: getMediumStyle(
                            color: AppColors.primary,
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
                    text: AppStrings.openInGoogleMaps,
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
                      color: AppColors.primary50,
                      borderRadius:
                          BorderRadius.circular(AppRadius.s12),
                    ),
                    child: Icon(Icons.phone_rounded,
                        size: 22.sp, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.s12),

            // Arrived button
            AppButton(
              text: _isToCustomer && widget.args.isFuel
                  ? 'وصلت - بدء التعبئة'
                  : AppStrings.arrivedStartDoc,
              onPressed: _onArrivedTapped,
            ),
          ],
        ),
      );
}
