import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/cubits/location_state.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Pair of wide action cards on the home screen:
///   • Fuel — live map background with "Order Fuel" overlay
///   • Tow  — dark gradient card
class HomeActionCards extends StatelessWidget {
  const HomeActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Row(
      children: [
        Expanded(
          child: _FuelMapCard(
            title: l10n.fuelNowTitle,
            onTap: () => Navigator.pushNamed(context, Routes.fuelType),
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: _ActionCard(
            title: l10n.searchTowing,
            subtitle: l10n.towNowSubtitle,
            icon: Icons.fire_truck_rounded,
            gradient: const [Color(0xFF37434E), Color(0xFF222B33)],
            shadowColor: const Color(0xFF222B33),
            onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
          ),
        ),
      ],
    );
  }
}

/// Fuel action card backed by a live (non-interactive) Google Map centered on
/// the user's saved location (or Tripoli fallback), with an "Order Fuel"
/// overlay. Tapping anywhere routes to the fuel-type flow.
class _FuelMapCard extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _FuelMapCard({required this.title, required this.onTap});

  // Sensible fallback for Libyan users when we don't yet have a saved location.
  static const LatLng _fallbackTripoli = LatLng(32.8872, 13.1913);

  @override
  State<_FuelMapCard> createState() => _FuelMapCardState();
}

class _FuelMapCardState extends State<_FuelMapCard> {
  GoogleMapController? _controller;

  LatLng _targetOf(LocationState s) => (s.lat != null && s.lng != null)
      ? LatLng(s.lat!, s.lng!)
      : _FuelMapCard._fallbackTripoli;

  @override
  Widget build(BuildContext context) {
    // Only rebuild / re-animate on actual coordinate changes — address-only
    // emits from reverse-geocode shouldn't tear down the platform view.
    return BlocConsumer<LocationCubit, LocationState>(
      buildWhen: (a, b) => a.lat != b.lat || a.lng != b.lng,
      listenWhen: (a, b) => a.lat != b.lat || a.lng != b.lng,
      listener: (context, state) {
        // Post-mount recentering — initialCameraPosition is only read once.
        _controller?.animateCamera(CameraUpdate.newLatLng(_targetOf(state)));
      },
      builder: (context, state) {
        final target = _targetOf(state);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppRadius.s20),
            splashColor: AppColors.white.withValues(alpha: 0.12),
            highlightColor: AppColors.white.withValues(alpha: 0.06),
            child: Container(
              height: 112.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.s20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.s20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Live map background — decorative, so absorb all pointers
                    // and let the parent InkWell handle the tap.
                    AbsorbPointer(
                      child: GoogleMap(
                        initialCameraPosition:
                            CameraPosition(target: target, zoom: 14),
                        liteModeEnabled: true, // Android: cheap static render
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        onMapCreated: (c) => _controller = c,
                        markers: {
                          Marker(
                            markerId: const MarkerId('order_fuel_pin'),
                            position: target,
                          ),
                        },
                      ),
                    ),
                    // Dark scrim for text legibility over map colors.
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.black.withValues(alpha: 0.15),
                            AppColors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Insets.s12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.local_gas_station_rounded,
                                color: AppColors.white,
                                size: 26.sp,
                              ),
                              Container(
                                width: 26.w,
                                height: 26.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      AppColors.white.withValues(alpha: 0.20),
                                ),
                                child: DirectionalServiceIcon(
                                  Icons.arrow_forward_rounded,
                                  size: 15.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              color: AppColors.white,
                              fontSize: FontSize.s16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s20),
        splashColor: AppColors.white.withValues(alpha: 0.12),
        highlightColor: AppColors.white.withValues(alpha: 0.06),
        child: Ink(
          height: 112.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(AppRadius.s20),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.30),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s20),
            child: Stack(
              children: [
                // Decorative translucent circle (echoes the header style)
                PositionedDirectional(
                  end: -22.w,
                  top: -22.w,
                  child: Container(
                    width: 84.w,
                    height: 84.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Insets.s12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Truck faces the road direction in Arabic (RTL).
                          Transform.flip(
                            flipX: Directionality.of(context) ==
                                TextDirection.rtl,
                            child: Icon(icon,
                                color: AppColors.white, size: 26.sp),
                          ),
                          Container(
                            width: 26.w,
                            height: 26.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.15),
                            ),
                            child: DirectionalServiceIcon(
                              Icons.arrow_forward_rounded,
                              size: 15.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                                color: AppColors.white,
                                fontSize: FontSize.s16),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getRegularStyle(
                                color:
                                    AppColors.white.withValues(alpha: 0.75),
                                fontSize: FontSize.s12),
                          ),
                        ],
                      ),
                    ],
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
