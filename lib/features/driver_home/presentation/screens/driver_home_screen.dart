import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool _isActive = true;

  void _showOrderBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OrderPopupCard(),
    );
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
            _buildMapPlaceholder(),
            _buildTopBar(),
            _buildSideButtons(),
            _buildBottomPanel(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showOrderBottomSheet,
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.notifications_active_outlined,
            color: AppColors.white,
            size: 24.w,
          ),
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.lightGrey,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64.w,
              color: AppColors.neutral600,
            ),
            SizedBox(height: Sizes.s8),
            Text(
              'خريطة',
              style: getMediumStyle(
                color: AppColors.neutral800,
                fontSize: FontSize.s18,
              ),
            ),
          ],
        ),
      ),
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
              // Hamburger menu (leading in RTL = right side visually)
              _buildCircularButton(
                icon: Icons.menu_rounded,
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const Spacer(),
              // Status toggle in center
              DriverStatusToggle(
                initialActive: _isActive,
                onStatusChanged: (active) {
                  setState(() => _isActive = active);
                },
              ),
              const Spacer(),
              // Notification bell (trailing in RTL = left side visually)
              _buildCircularButton(
                icon: Icons.notifications_outlined,
                onTap: () {
                  // TODO: navigate to notifications
                },
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
    // In RTL, "left" in code positions on the right visually
    return PositionedDirectional(
      start: Insets.s16,
      bottom: 220.h,
      child: Column(
        children: [
          _buildCircularButton(
            icon: Icons.refresh_rounded,
            onTap: () {
              // TODO: refresh location / orders
            },
          ),
          SizedBox(height: Sizes.s12),
          _buildCircularButton(
            icon: Icons.my_location_rounded,
            onTap: () {
              // TODO: center on driver location
            },
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
      child: Container(
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
      ),
    );
  }

  Widget _buildSearchingState() {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
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
          decoration: BoxDecoration(
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
