import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
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
      setState(() => _serviceType = state.profile.serviceType);
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
            ));
        break;
      case 'arrived':
        if (req.isFuelDelivery) {
          // Fuel: go to refueling screen
          Navigator.pushNamed(context, Routes.driverRefueling,
              arguments: DriverRefuelingArgs(
                orderId: orderId,
                amount: double.tryParse(req.total ?? '0') ?? 0,
              ));
        } else {
          Navigator.pushNamed(context, Routes.driverDocumentation,
              arguments: DriverDocumentationArgs(
                orderId: orderId,
                documentationType: 'pickup',
                amount: double.tryParse(req.total ?? '0') ?? 0,
              ));
        }
        break;
      case 'in_progress':
        Navigator.pushNamed(context, Routes.driverCollectPayment,
            arguments: DriverCollectPaymentArgs(
              orderId: orderId,
              amount: double.tryParse(req.total ?? '0') ?? 0,
            ));
        break;
    }
  }

  void _showCancelledSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم إلغاء الطلب من قبل العميل'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
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
                          _MapControlButton(icon: Icons.notifications_outlined, onTap: () => Navigator.pushNamed(context, Routes.notifications)),
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

                // ── Active order resume card ──
                if (_activeRequest != null && _pendingRequest == null)
                  Positioned(
                    left: Insets.s16, right: Insets.s16, bottom: 140.h,
                    child: _ActiveOrderCard(
                      request: _activeRequest!,
                      onResume: () => _resumeActiveOrder(_activeRequest!),
                    ),
                  ),

                // ── Bottom panel: searching or order popup ──
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: _pendingRequest != null
                      ? OrderPopupCard(
                          key: ValueKey(_pendingRequest!.id),
                          request: _pendingRequest,
                          onAccept: _onAcceptOrder,
                          onReject: _onRejectOrder,
                        )
                      : _SearchingPanel(
                          isActive: _isActive,
                          serviceType: _serviceType,
                          onActivate: () => _onStatusChanged(true),
                        ),
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

class _SearchingPanel extends StatefulWidget {
  final bool isActive;
  final String serviceType;
  final VoidCallback onActivate;
  const _SearchingPanel({
    required this.isActive,
    required this.serviceType,
    required this.onActivate,
  });

  @override
  State<_SearchingPanel> createState() => _SearchingPanelState();
}

class _SearchingPanelState extends State<_SearchingPanel>
    with TickerProviderStateMixin {
  late final AnimationController _radarController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _radarController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFuel = widget.serviceType != 'towing';
    final accentColor = isFuel
        ? const Color(0xFF1A6B54)
        : const Color(0xFF1565C0);
    final accentLight = isFuel
        ? const Color(0xFF2A9D6E)
        : const Color(0xFF2979FF);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 30,
              offset: const Offset(0, -6),
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
              margin: EdgeInsets.only(top: 12.h, bottom: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFDCDFE3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            if (widget.isActive) ...[
              // ── Active: Searching state ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        accentColor.withValues(alpha: 0.06),
                        accentLight.withValues(alpha: 0.03),
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
                      SizedBox(height: 14.h),
                      Text(
                        isFuel
                            ? 'جارٍ البحث عن طلبات الوقود...'
                            : 'جارٍ البحث عن طلبات السحب...',
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s16,
                          color: const Color(0xFF111827),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppStrings.searchingSubtitle,
                        style: getRegularStyle(
                          fontSize: FontSize.s13,
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Status chips row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Row(
                  children: [
                    // Live chip
                    _StatusChip(
                      dotColor: AppColors.success,
                      label: 'متصل ونشط',
                      labelColor: AppColors.success,
                      bgColor: AppColors.success.withValues(alpha: 0.08),
                    ),
                    SizedBox(width: 8.w),
                    // Service type chip
                    _StatusChip(
                      dotColor: accentColor,
                      label: isFuel ? 'إمداد وقود' : 'خدمة ساحبة',
                      labelColor: accentColor,
                      bgColor: accentColor.withValues(alpha: 0.08),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // ── Inactive: Banner + Slide to activate ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Column(
                  children: [
                    // Service info banner
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [accentColor, accentLight],
                        ),
                        borderRadius: BorderRadius.circular(18.r),
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
                          // Icon container
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Icon(
                              isFuel
                                  ? Icons.local_gas_station_rounded
                                  : Icons.fire_truck_rounded,
                              color: Colors.white,
                              size: 26.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isFuel ? 'خدمة إمداد الوقود' : 'خدمة الساحبة',
                                  style: getBoldStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s15,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'فعّل حالتك لبدء استقبال الطلبات',
                                  style: getRegularStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Status indicator
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7.w,
                                  height: 7.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFB400),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFB400).withValues(alpha: 0.6),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'غير نشط',
                                  style: getMediumStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Slide to activate
                    SlideToActivate(
                      onActivate: widget.onActivate,
                      label: 'اسحب للتفعيل',
                      icon: isFuel
                          ? Icons.local_gas_station_rounded
                          : Icons.fire_truck_rounded,
                      gradientColors: [accentColor, accentLight],
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }
}

// ── Small status chip ──
class _StatusChip extends StatelessWidget {
  final Color dotColor;
  final String label;
  final Color labelColor;
  final Color bgColor;
  const _StatusChip({
    required this.dotColor,
    required this.label,
    required this.labelColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: getMediumStyle(
              fontSize: FontSize.s12,
              color: labelColor,
            ),
          ),
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
  const _ActiveOrderCard({required this.request, required this.onResume});

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

  String get _statusLabel {
    switch (widget.request.status) {
      case 'accepted':  return 'تم القبول';
      case 'en_route':  return 'في الطريق للعميل';
      case 'arrived':   return widget.request.isFuelDelivery ? 'جاري التعبئة' : 'وصلت';
      case 'in_progress': return widget.request.isFuelDelivery ? 'تحصيل المبلغ' : 'قيد التنفيذ';
      default: return widget.request.status;
    }
  }

  Color get _statusColor {
    switch (widget.request.status) {
      case 'accepted':    return const Color(0xFF2979FF);
      case 'en_route':    return const Color(0xFFFF9800);
      case 'arrived':     return const Color(0xFF1A6B54);
      case 'in_progress': return const Color(0xFF7C3AED);
      default: return AppColors.primary;
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
            color: AppColors.white,
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                              ? 'طلب وقود نشط'
                              : 'طلب ساحبة نشط',
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
                                _statusLabel,
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
              // Resume button
              GestureDetector(
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
                        'متابعة الطلب',
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ],
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
    if (_completed || _trackWidth <= _thumbSize) return;
    final travel = _trackWidth - _thumbSize;
    // RTL: dragging left (negative dx) should increase progress.
    setState(() {
      _dragPosition =
          (_dragPosition + (-details.delta.dx / travel)).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_completed) return;
    if (_dragPosition >= _completionThreshold) {
      // Snap to fully completed, then fire callback.
      setState(() => _completed = true);
      _animateTo(1.0);
      Future.delayed(const Duration(milliseconds: 260), () {
        if (!mounted) return;
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
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
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
                        textDirection: TextDirection.rtl,
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
                      color: Colors.white,
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
          color: AppColors.white,
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

