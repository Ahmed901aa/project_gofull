import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/order_polling_service.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_refueling_screen.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_state.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import '../widgets/driver_drawer.dart';
import '../widgets/driver_status_toggle.dart';
import '../widgets/order_popup_card.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  static const _defaultLat = 32.1194;
  static const _defaultLng = 20.0868;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;
  final _polling = OrderPollingService();
  late final ProviderBloc _providerBloc;

  bool _isActive = false;
  String _serviceType = 'fuel_delivery'; // default, updated from profile
  ServiceRequestEntity? _pendingRequest; // real request from backend
  ServiceRequestEntity? _activeRequest;  // accepted/en_route/arrived/in_progress
  Timer? _activeRequestTimer;

  @override
  void initState() {
    super.initState();
    _providerBloc = sl<ProviderBloc>();
    // Load provider profile to determine service type
    _providerBloc.add(const LoadProfileEvent());
    // Check for any active/in-progress order (resumes after back navigation)
    _providerBloc.add(const LoadActiveRequestEvent());
    _activeRequestTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        _providerBloc.add(const LoadActiveRequestEvent());
      }
    });
  }

  @override
  void dispose() {
    _polling.dispose();
    _activeRequestTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // ── Auto-status rule ──
  // When the officer has an active order, status is forced to "active" and the
  // toggle is disabled. When the order ends, it restores the previous state.
  bool get _effectivelyActive => _activeRequest != null || _isActive;
  bool get _statusLocked => _activeRequest != null;

  // ── Status toggle ──

  void _onStatusChanged(bool active) {
    // Block manual toggle while an order is in progress
    if (_statusLocked) {

      return;

    }

    setState(() {
      _isActive = active;
      _pendingRequest = null;
    });

    _providerBloc.add(ToggleAvailabilityEvent(active));

    if (active) {
      _polling.start(
        interval: const Duration(seconds: 5),
        callback: () async {
          if (_isActive) {
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
    if (state is ProfileLoaded) {
      setState(() {
        _serviceType = state.profile.serviceType;
        // Sync the toggle with the backend availability
        _isActive = state.profile.isAvailable;
      });
      // If already active, start polling for orders
      if (_isActive && _activeRequest == null) {
        _polling.start(
          interval: const Duration(seconds: 5),
          callback: () async {
            if (_isActive && _pendingRequest == null) {
              _providerBloc.add(const LoadPendingRequestsEvent());
            }
          },
        );
      }
      return;
    }
    if (state is OrderCancelledByProvider) {
      setState(() {
        _activeRequest = null;
        _pendingRequest = null;
      });
      // Reload profile to get the restored availability
      _providerBloc.add(const LoadProfileEvent());
      if (mounted) {
        AppSnackbar.success(context, S.of(context).orderCancelledSuccessSnack);
      }
      return;
    }
    if (state is ActiveRequestLoaded) {
      final req = state.request;

      // Only treat as cancelled if the API explicitly returns 'cancelled' status
      final wasCancelled = _activeRequest != null &&
          req != null &&
          req.status == 'cancelled';

      // Update state: clear if cancelled or null (completed/no order)
      if (req == null || req.status == 'cancelled' || req.status == 'completed') {
        setState(() => _activeRequest = null);
      } else {
        setState(() => _activeRequest = req);
      }

      // Show cancellation message only for actual cancellations
      if (wasCancelled && mounted) {
        Navigator.popUntil(context,
            (route) => route.settings.name == Routes.driverHome || route.isFirst);
        _showCancelledSnackBar();
      }
    } else if (state is PendingRequestsLoaded) {
      setState(() {
        _pendingRequest = state.requests.isNotEmpty ? state.requests.first : null;
      });
    } else if (state is RequestAccepted) {
      _polling.stop();
      final req = state.request;
      setState(() {
        _activeRequest = req;
        _pendingRequest = null;
      });
      // Skip order details — go directly to navigate
      final customerPhone = (req.driverInfo?['phone'] as String?) ?? '';
      Navigator.pushNamed(
        context,
        Routes.driverNavigate,
        arguments: DriverNavigateArgs(
          orderId: req.id.toString(),
          address: req.driverAddress ?? '',
          lat: double.tryParse(req.driverLatitude),
          lng: double.tryParse(req.driverLongitude),
          navigationType: 'to_customer',
          serviceType: req.isFuelDelivery ? 'fuel' : 'towing',
          amount: double.tryParse(req.total ?? '0') ?? 0,
          customerPhone: customerPhone,
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

  void _resumeActiveOrder(ServiceRequestEntity req) {
    final orderId = req.id.toString();
    final customerPhone = (req.driverInfo?['phone'] as String?) ?? '';
    switch (req.status) {
      case 'accepted':
        Navigator.pushNamed(context, Routes.driverNavigate,
            arguments: DriverNavigateArgs(
              orderId: orderId,
              address: req.driverAddress ?? '',
              lat: double.tryParse(req.driverLatitude),
              lng: double.tryParse(req.driverLongitude),
              navigationType: 'to_customer',
              serviceType: req.isFuelDelivery ? 'fuel' : 'towing',
              amount: double.tryParse(req.total ?? '0') ?? 0,
              customerPhone: customerPhone,
            ));
        break;
      case 'en_route':
        Navigator.pushNamed(context, Routes.driverNavigate,
            arguments: DriverNavigateArgs(
              orderId: orderId,
              address: req.driverAddress ?? '',
              lat: double.tryParse(req.driverLatitude),
              lng: double.tryParse(req.driverLongitude),
              navigationType: 'to_customer',
              serviceType: req.isFuelDelivery ? 'fuel' : 'towing',
              amount: double.tryParse(req.total ?? '0') ?? 0,
              customerPhone: customerPhone,
            ));
        break;
      case 'arrived':
        if (req.isFuelDelivery) {
          Navigator.pushNamed(context, Routes.driverRefueling,
              arguments: DriverRefuelingArgs(
                orderId: orderId,
                amount: double.tryParse(req.total ?? '0') ?? 0,
                customerPhone: customerPhone,
              ));
        } else {
          Navigator.pushNamed(context, Routes.driverDocumentation,
              arguments: DriverDocumentationArgs(
                orderId: orderId,
                documentationType: 'pickup',
                amount: double.tryParse(req.total ?? '0') ?? 0,
                customerPhone: customerPhone,
              ));
        }
        break;
      case 'in_progress':
        Navigator.pushNamed(context, Routes.driverCollectPayment,
            arguments: DriverCollectPaymentArgs(
              orderId: orderId,
              amount: double.tryParse(req.total ?? '0') ?? 0,
              customerPhone: customerPhone,
            ));
        break;
    }
  }

  void _showCancelledSnackBar() {
    if (!mounted) {

      return;

    }
    AppSnackbar.warning(context, S.of(context).orderCancelledByCustomerSnack);
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

  void _onCancelActiveOrder(ServiceRequestEntity request) async {
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
      _providerBloc.add(CancelOrderEvent(id: request.id));
    }
  }

  // ── Map controls ──

  Future<void> _moveToMyLocation() async {
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
                          DriverStatusToggle(isActive: _effectivelyActive, onChanged: _statusLocked ? null : _onStatusChanged),
                          const Spacer(),
                          _MapControlButton(icon: Icons.notifications_outlined, onTap: () => Navigator.pushNamed(context, Routes.notifications)),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Map control buttons ──
                Positioned(
                  left: Insets.s16,
                  bottom: _pendingRequest != null
                      ? 380.h
                      : _effectivelyActive ? 280.h : 140.h,
                  child: Column(
                    children: [
                      _MapControlButton(icon: Icons.refresh_rounded, onTap: _refreshMap),
                      SizedBox(height: Insets.s8),
                      _MapControlButton(icon: Icons.my_location_rounded, onTap: _moveToMyLocation),
                    ],
                  ),
                ),

                // ── Active order resume card ──
                if (_activeRequest != null && _pendingRequest == null)
                  Positioned(
                    left: Insets.s16, right: Insets.s16, bottom: 140.h,
                    child: _ActiveOrderCard(
                      request: _activeRequest!,
                      onResume: () => _resumeActiveOrder(_activeRequest!),
                      onCancel: () => _onCancelActiveOrder(_activeRequest!),
                    ),
                  ),

                // ── Bottom panel ──
                if (_pendingRequest != null)
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: OrderPopupCard(
                      key: ValueKey(_pendingRequest!.id),
                      request: _pendingRequest,
                      onAccept: _onAcceptOrder,
                      onReject: _onRejectOrder,
                    ),
                  )
                else
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: _ProviderBottomPanel(
                      isActive: _effectivelyActive,
                      serviceType: _serviceType,
                      onToggle: _statusLocked ? null : () => _onStatusChanged(!_isActive),
                    ),
                  ),
              ],
            ),
          ),
        ),
    );
  }
}

// ── Provider bottom panel (inactive / active searching) ──

class _ProviderBottomPanel extends StatefulWidget {
  final bool isActive;
  final String serviceType;
  final VoidCallback? onToggle;
  const _ProviderBottomPanel({
    required this.isActive,
    required this.serviceType,
    this.onToggle,
  });

  @override
  State<_ProviderBottomPanel> createState() => _ProviderBottomPanelState();
}

class _ProviderBottomPanelState extends State<_ProviderBottomPanel>
    with TickerProviderStateMixin {
  late final AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFuel = widget.serviceType != 'towing';
    final accentColor = isFuel
        ? context.colors.primaryLight
        : const Color(0xFF1565C0);
    final accentLight = isFuel
        ? const Color(0xFF2A9D6E)
        : const Color(0xFF2979FF);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFDCDFE3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          if (widget.isActive) ...[
            // ── Active: searching for orders ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topEnd,
                    end: AlignmentDirectional.bottomStart,
                    colors: [
                      accentColor.withValues(alpha: 0.06),
                      accentLight.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    _RadarSearchAnimation(
                      controller: _radarController,
                      color: accentColor,
                      icon: isFuel
                          ? Icons.local_gas_station_rounded
                          : Icons.fire_truck_rounded,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      isFuel
                          ? S.of(context).searchingFuelOrders
                          : S.of(context).searchingTowOrders,
                      style: getSemiBoldStyle(
                        fontSize: FontSize.s15,
                        color: const Color(0xFF111827),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      S.of(context).searchingSubtitle,
                      style: getRegularStyle(
                        fontSize: FontSize.s12,
                        color: context.colors.iconSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Stop button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: GestureDetector(
                onTap: widget.onToggle,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: context.colors.errorSurface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0xFFFCA5A5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stop_circle_outlined,
                          size: 20.sp, color: context.colors.error),
                      SizedBox(width: 6.w),
                      Text(
                        S.of(context).stopPatrol,
                        style: getSemiBoldStyle(
                          color: context.colors.error,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // ── Inactive: ready to start ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topEnd,
                    end: AlignmentDirectional.bottomStart,
                    colors: [accentColor, accentLight],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Service icon
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: context.colors.surface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        isFuel
                            ? Icons.local_gas_station_rounded
                            : Icons.fire_truck_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isFuel ? S.of(context).fuelPatrol : S.of(context).towingPatrol,
                            style: getBoldStyle(
                              color: Colors.white,
                              fontSize: FontSize.s15,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            S.of(context).tapToStartOrders,
                            style: getRegularStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Start button
                    GestureDetector(
                      onTap: widget.onToggle,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          S.of(context).startButton,
                          style: getBoldStyle(
                            color: accentColor,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

/// Radar-style search animation: concentric rings expanding outward
/// around a centered service icon.
class _RadarSearchAnimation extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final IconData icon;
  const _RadarSearchAnimation({
    required this.controller,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110.w,
      height: 110.w,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _ring(controller.value),
              _ring((controller.value + 0.33) % 1.0),
              _ring((controller.value + 0.66) % 1.0),
              // Core icon
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      color,
                      color.withValues(alpha: 0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, size: 26.sp, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _ring(double progress) {
    final size = 52.w + (58.w * progress);
    final opacity = (1 - progress).clamp(0.0, 1.0) * 0.55;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: opacity),
          width: 2,
        ),
      ),
    );
  }
}

// ── Active order resume card ──────────────────────────────

class _ActiveOrderCard extends StatefulWidget {
  final ServiceRequestEntity request;
  final VoidCallback onResume;
  final VoidCallback onCancel;
  const _ActiveOrderCard({required this.request, required this.onResume, required this.onCancel});

  @override
  State<_ActiveOrderCard> createState() => _ActiveOrderCardState();
}

class _ActiveOrderCardState extends State<_ActiveOrderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _statusLabel(BuildContext context) {
    final l10n = S.of(context);
    switch (widget.request.status) {
      case 'accepted':  return l10n.statusAccepted;
      case 'en_route':  return l10n.statusEnRouteToCustomer;
      case 'arrived':   return widget.request.isFuelDelivery ? l10n.statusRefueling : l10n.statusArrived;
      case 'in_progress': return widget.request.isFuelDelivery ? l10n.statusCollecting : l10n.statusInProgressLabel;
      default: return widget.request.status;
    }
  }

  Color get _statusColor {
    switch (widget.request.status) {
      case 'accepted':    return const Color(0xFF2979FF);
      case 'en_route':    return const Color(0xFFFF9800);
      case 'arrived':     return context.colors.primaryLight;
      case 'in_progress': return const Color(0xFF7C3AED);
      default: return context.colors.primary;
    }
  }

  IconData get _statusIcon {
    switch (widget.request.status) {
      case 'accepted':    return Icons.check_circle_outline_rounded;
      case 'en_route':    return Icons.navigation_rounded;
      case 'arrived':     return Icons.place_rounded;
      case 'in_progress': return Icons.play_circle_outline_rounded;
      default: return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _statusColor;
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final pulseValue = _pulseController.value;
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.08 + pulseValue * 0.06),
                blurRadius: 20 + pulseValue * 8,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: accentColor.withValues(alpha: 0.15 + pulseValue * 0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Icon with accent bg
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [
                          accentColor,
                          accentColor.withValues(alpha: 0.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.request.isFuelDelivery
                          ? Icons.local_gas_station_rounded
                          : Icons.fire_truck_rounded,
                      size: 24.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Order info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.request.isFuelDelivery
                              ? S.of(context).activeFuelOrder
                              : S.of(context).activeTowOrder,
                          style: getBoldStyle(
                            color: const Color(0xFF111827),
                            fontSize: FontSize.s15,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        // Status badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _statusIcon,
                                size: 14.sp,
                                color: accentColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _statusLabel(context),
                                style: getMediumStyle(
                                  color: accentColor,
                                  fontSize: FontSize.s12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Resume + Cancel buttons
              Row(
                children: [
                  // Cancel button
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: context.colors.errorSurface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Icon(Icons.close_rounded, size: 22.sp, color: context.colors.error),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Resume button
                  Expanded(child: GestureDetector(
                onTap: widget.onResume,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withValues(alpha: 0.85)],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded,
                          size: 20.sp, color: Colors.white),
                      SizedBox(width: 6.w),
                      Text(
                        S.of(context).resumeOrderBtn,
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ],
                  ),
                ),
              )), // close Expanded + GestureDetector
                ],
              ), // close Row
            ],
          ),
        );
      },
    );
  }
}

// ── Slide-to-activate bar (RTL-aware) ──────────────────────

/// A "slide-to-unlock" style activation widget. The thumb starts at the right
/// edge (RTL start) and the user drags it to the left (RTL end). Once dragged
/// past the completion threshold, [onActivate] is called.
class SlideToActivate extends StatefulWidget {
  final VoidCallback onActivate;
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final double height;

  const SlideToActivate({
    super.key,
    required this.onActivate,
    required this.label,
    required this.icon,
    required this.gradientColors,
    this.height = 60,
  });

  @override
  State<SlideToActivate> createState() => _SlideToActivateState();
}

class _SlideToActivateState extends State<SlideToActivate>
    with TickerProviderStateMixin {
  double _dragPosition = 0; // 0 = thumb at right, 1 = thumb at left
  double _trackWidth = 0;
  bool _completed = false;

  late final AnimationController _shimmerController;
  late final AnimationController _snapController;
  Animation<double>? _snapAnim;

  static const double _completionThreshold = 0.85;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        if (_snapAnim != null) {
          setState(() => _dragPosition = _snapAnim!.value);
        }
      });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _snapController.dispose();
    super.dispose();
  }

  double get _thumbSize => widget.height - 6;

  void _onDragUpdate(DragUpdateDetails details) {
    if (_completed || _trackWidth <= _thumbSize) {

      return;

    }
    final travel = _trackWidth - _thumbSize;
    // RTL: dragging left (negative dx) should increase progress.
    setState(() {
      _dragPosition =
          (_dragPosition + (-details.delta.dx / travel)).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_completed) {

      return;

    }
    if (_dragPosition >= _completionThreshold) {
      // Snap to fully completed, then fire callback.
      setState(() => _completed = true);
      _animateTo(1.0);
      Future.delayed(const Duration(milliseconds: 260), () {
        if (!mounted) {

          return;

        }
        widget.onActivate();
      });
    } else {
      _animateTo(0.0);
    }
  }

  void _animateTo(double target) {
    _snapAnim = Tween<double>(begin: _dragPosition, end: target).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic),
    );
    _snapController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _trackWidth = constraints.maxWidth;
        final travel = _trackWidth - _thumbSize;
        final thumbRight = _dragPosition * travel;
        final labelOpacity = (1 - _dragPosition * 1.4).clamp(0.0, 1.0);

        final baseColors = widget.gradientColors;
        final fillColors = [
          baseColors.first.withValues(alpha: 0.85 + 0.15 * _dragPosition),
          baseColors.last,
        ];

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.centerEnd,
              end: AlignmentDirectional.centerStart,
              colors: fillColors,
            ),
            borderRadius: BorderRadius.circular(widget.height / 2),
            boxShadow: [
              BoxShadow(
                color: baseColors.last.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Crisp, static label — centered, high-contrast, always visible.
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: labelOpacity,
                    child: Center(
                      child: Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontWeight: FontWeightManager.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                          letterSpacing: 0.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Animated arrow hint on the left (drag direction).
              Positioned(
                left: 16.w,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: labelOpacity * 0.9,
                    child: AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, _) {
                        final t = _shimmerController.value;
                        final nudge = (1 - (t - 0.5).abs() * 2) * 5.w;
                        return Transform.translate(
                          offset: Offset(-nudge, 0),
                          child: Icon(
                            Icons.keyboard_double_arrow_left_rounded,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 22.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Thumb
              Positioned(
                right: 3 + thumbRight,
                top: 3,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _completed
                        ? Padding(
                            padding: EdgeInsets.all(14.w),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                baseColors.last,
                              ),
                            ),
                          )
                        : Icon(
                            widget.icon,
                            color: baseColors.last,
                            size: 24.sp,
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
        width: 46.w,
        height: 46.w,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 22.sp, color: const Color(0xFF1a1a1a)),
      ),
    );
  }
}

