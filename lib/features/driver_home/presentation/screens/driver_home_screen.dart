import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_state.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import '../widgets/driver_drawer.dart';
import '../widgets/driver_status_toggle.dart';
import '../widgets/order_popup_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  static const _defaultLat = 24.7136;
  static const _defaultLng = 46.6753;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;
  final _polling = OrderPollingService();
  late final ProviderBloc _providerBloc;

  bool _isActive = false;
  ServiceRequestEntity? _pendingRequest; // real request from backend

  @override
  void initState() {
    super.initState();
    _providerBloc = sl<ProviderBloc>();
  }

  @override
  void dispose() {
    _polling.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ── Status toggle ──

  void _onStatusChanged(bool active) {
    setState(() {
      _isActive = active;
      _pendingRequest = null;
    });

    // Toggle availability on backend
    _providerBloc.add(ToggleAvailabilityEvent(active));

    if (active) {
      // Start polling for pending requests every 5 seconds
      _polling.start(
        interval: const Duration(seconds: 5),
        callback: () async {
          if (_isActive && _pendingRequest == null) {
            _providerBloc.add(const LoadPendingRequestsEvent());
          }
        },
      );
    } else {
      _polling.stop();
    }
  }

  // ── Handle polling results ──

  void _onProviderState(ProviderState state) {
    if (state is PendingRequestsLoaded && state.requests.isNotEmpty) {
      setState(() => _pendingRequest = state.requests.first);
    } else if (state is RequestAccepted) {
      _polling.stop();
      // Navigate to order details with real data
      Navigator.pushNamed(
        context,
        Routes.driverOrderDetails,
        arguments: DriverOrderDetailsArgs(
          orderId: state.request.id.toString(),
          serviceType: state.request.isFuelDelivery ? 'fuel' : 'towing',
          customerName: (state.request.driverInfo?['name'] as String?) ?? 'العميل',
          customerPhone: (state.request.driverInfo?['phone'] as String?) ?? '',
          pickupAddress: state.request.driverAddress ?? '',
          deliveryAddress: '',
          carType: '',
          plateNumber: state.request.plateNumber ?? '',
          distance: 0,
          amount: 0,
          fuelType: state.request.fuelType,
          fuelQuantity: state.request.fuelQuantity,
        ),
      );
    } else if (state is RequestRejected) {
      setState(() => _pendingRequest = null);
      // Resume polling after rejection
      if (_isActive) {
        _polling.start(
          interval: const Duration(seconds: 5),
          callback: () async {
            if (_isActive && _pendingRequest == null) {
              _providerBloc.add(const LoadPendingRequestsEvent());
            }
          },
        );
      }
    }
  }

  // ── Order actions ──

  void _onAcceptOrder() {
    if (_pendingRequest != null) {
      _polling.stop();
      _providerBloc.add(AcceptRequestEvent(_pendingRequest!.id));
    }
  }

  void _onRejectOrder() {
    if (_pendingRequest != null) {
      _providerBloc.add(RejectRequestEvent(_pendingRequest!.id));
    }
    setState(() => _pendingRequest = null);
  }

  // ── Map controls ──

  Future<void> _moveToMyLocation() async {
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
        CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15),
      );
    } catch (_) {}
  }

  void _refreshMap() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(const LatLng(_defaultLat, _defaultLng), 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _providerBloc,
      child: BlocListener<ProviderBloc, ProviderState>(
        listener: (context, state) => _onProviderState(state),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: _scaffoldKey,
            drawer: const DriverDrawer(),
            body: Stack(
              children: [
                // ── Full-screen Google Map ──
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(_defaultLat, _defaultLng), zoom: 13,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _moveToMyLocation();
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                ),

                // ── Top bar overlay ──
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
                      child: Row(
                        children: [
                          _MapControlButton(icon: Icons.menu_rounded, onTap: () => _scaffoldKey.currentState?.openDrawer()),
                          const Spacer(),
                          DriverStatusToggle(isActive: _isActive, onChanged: _onStatusChanged),
                          const Spacer(),
                          _MapControlButton(icon: Icons.notifications_outlined, onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Map control buttons ──
                Positioned(
                  left: Insets.s16,
                  bottom: _pendingRequest != null ? 380.h : 160.h,
                  child: Column(
                    children: [
                      _MapControlButton(icon: Icons.refresh_rounded, onTap: _refreshMap),
                      SizedBox(height: Insets.s8),
                      _MapControlButton(icon: Icons.my_location_rounded, onTap: _moveToMyLocation),
                    ],
                  ),
                ),

                // ── Bottom panel: searching or order popup ──
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: _pendingRequest != null
                      ? OrderPopupCard(
                          request: _pendingRequest,
                          onAccept: _onAcceptOrder,
                          onReject: _onRejectOrder,
                        )
                      : _SearchingPanel(isActive: _isActive),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Searching panel shown when no orders ──

class _SearchingPanel extends StatelessWidget {
  final bool isActive;
  const _SearchingPanel({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Insets.s16),
      padding: EdgeInsets.symmetric(horizontal: Insets.s20, vertical: Insets.s20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40.w, height: 4.h, margin: EdgeInsets.only(bottom: Insets.s16), decoration: BoxDecoration(color: AppColors.neutral600, borderRadius: BorderRadius.circular(2.r))),
          if (isActive) ...[
            SizedBox(width: 40.w, height: 40.w, child: CircularProgressIndicator(strokeWidth: 3.w, color: AppColors.primary)),
            SizedBox(height: Insets.s12),
            Text(AppStrings.searchingForOrder, style: getSemiBoldStyle(fontSize: FontSize.s16, color: AppColors.black), textAlign: TextAlign.center),
            SizedBox(height: 4.h),
            Text(AppStrings.searchingSubtitle, style: getRegularStyle(fontSize: FontSize.s14, color: AppColors.grey), textAlign: TextAlign.center),
          ] else ...[
            Icon(Icons.local_shipping_outlined, size: 40.sp, color: AppColors.grey),
            SizedBox(height: Insets.s12),
            Text(AppStrings.inactive, style: getSemiBoldStyle(fontSize: FontSize.s16, color: AppColors.darkGrey), textAlign: TextAlign.center),
            SizedBox(height: 4.h),
            Text('قم بتفعيل حالتك لاستقبال الطلبات', style: getRegularStyle(fontSize: FontSize.s14, color: AppColors.grey), textAlign: TextAlign.center),
          ],
          SizedBox(height: Insets.s8),
        ],
      ),
    );
  }
}

// ── Circular map control button ──

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w, height: 44.w,
        decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))]),
        child: Icon(icon, size: 22.sp, color: AppColors.black),
      ),
    );
  }
}
