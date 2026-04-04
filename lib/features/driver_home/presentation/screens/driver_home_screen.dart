import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import '../widgets/driver_drawer.dart';
import '../widgets/driver_status_toggle.dart';
import '../widgets/order_popup_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;

  bool _isActive = true;
  bool _hasIncomingOrder = false;
  Timer? _orderTimer;

  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();
    if (_isActive) {
      _startOrderSearch();
    }
  }

  @override
  void dispose() {
    _orderTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _onStatusChanged(bool active) {
    setState(() {
      _isActive = active;
      if (!active) {
        _hasIncomingOrder = false;
        _orderTimer?.cancel();
      } else {
        _startOrderSearch();
      }
    });
  }

  void _startOrderSearch() {
    _orderTimer?.cancel();
    _orderTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _isActive) {
        setState(() => _hasIncomingOrder = true);
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _animateToCurrentLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_defaultLocation),
    );
  }

  void _refreshMap() {
    setState(() {
      _hasIncomingOrder = false;
    });
    if (_isActive) {
      _startOrderSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const DriverDrawer(),
        body: Stack(
          children: [
            _buildGoogleMap(),
            _buildTopBar(),
            _buildSideButtons(),
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: _defaultLocation,
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      markers: {
        Marker(
          markerId: const MarkerId('driver_location'),
          position: _defaultLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      },
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.s16,
            vertical: Insets.s8,
          ),
          child: Row(
            children: [
              _buildCircularButton(
                icon: Icons.menu_rounded,
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const Spacer(),
              DriverStatusToggle(
                initialActive: _isActive,
                onStatusChanged: _onStatusChanged,
              ),
              const Spacer(),
              _buildCircularButton(
                icon: Icons.notifications_outlined,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
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
        child: Icon(
          icon,
          size: 22.w,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }

  Widget _buildSideButtons() {
    return PositionedDirectional(
      start: Insets.s16,
      bottom: 220.h,
      child: Column(
        children: [
          _buildCircularButton(
            icon: Icons.refresh_rounded,
            onTap: _refreshMap,
          ),
          SizedBox(height: Sizes.s12),
          _buildCircularButton(
            icon: Icons.my_location_rounded,
            onTap: _animateToCurrentLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _isActive && _hasIncomingOrder
            ? OrderPopupCard(
                key: const ValueKey('order_popup'),
                onDismiss: () {
                  setState(() => _hasIncomingOrder = false);
                  _startOrderSearch();
                },
              )
            : _buildStatusPanel(),
      ),
    );
  }

  Widget _buildStatusPanel() {
    return Container(
      key: const ValueKey('status_panel'),
      padding: EdgeInsets.fromLTRB(
        Insets.s20,
        Insets.s20,
        Insets.s20,
        Insets.s32,
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.neutral600,
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
          ),
          SizedBox(height: Sizes.s20),
          _isActive ? _buildSearchingState() : _buildInactiveState(),
        ],
      ),
    );
  }

  Widget _buildSearchingState() {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: const BoxDecoration(
            color: AppColors.primary50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.search_rounded,
            size: 24.w,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: Sizes.s12),
        Text(
          AppStrings.searchingForOrder,
          style: getSemiBoldStyle(
            color: AppColors.darkGrey,
            fontSize: FontSize.s16,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Sizes.s8),
        Text(
          AppStrings.searchingSubtitle,
          style: getRegularStyle(
            color: AppColors.grey,
            fontSize: FontSize.s14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInactiveState() {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: const BoxDecoration(
            color: AppColors.neutral500,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.power_settings_new_rounded,
            size: 24.w,
            color: AppColors.grey,
          ),
        ),
        SizedBox(height: Sizes.s12),
        Text(
          AppStrings.inactive,
          style: getSemiBoldStyle(
            color: AppColors.darkGrey,
            fontSize: FontSize.s16,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Sizes.s8),
        Text(
          'قم بتفعيل حالتك لاستقبال الطلبات',
          style: getRegularStyle(
            color: AppColors.grey,
            fontSize: FontSize.s14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
