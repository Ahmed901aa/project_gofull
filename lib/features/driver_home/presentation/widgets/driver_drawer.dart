import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';

class DriverDrawer extends StatelessWidget {
  const DriverDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: Sizes.s8),
          _buildWalletCard(),
          SizedBox(height: Sizes.s8),
          Divider(color: AppColors.divider, height: 1),
          Expanded(child: _buildMenuList(context)),
          Divider(color: AppColors.divider, height: 1),
          _buildLogout(context),
          SizedBox(height: Sizes.s24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 60.h,
        bottom: Insets.s20,
        right: Insets.s20,
        left: Insets.s20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: AppColors.primaryLight,
            child: Icon(
              Icons.person,
              size: 36.w,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: Sizes.s12),
          Text(
            'محمود عبدالعليم',
            style: getBoldStyle(
              color: AppColors.white,
              fontSize: FontSize.s18,
            ),
          ),
          SizedBox(height: Sizes.s4),
          Text(
            AppStrings.towDriver,
            style: getRegularStyle(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: Sizes.s8),
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: 20.w,
                color: AppColors.gold,
              ),
              SizedBox(width: Insets.s4),
              Text(
                '4.8',
                style: getSemiBoldStyle(
                  color: AppColors.white,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s8,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.primary200),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 22.w,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.wallet,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '400- د.ك',
                    style: getBoldStyle(
                      color: AppColors.primary,
                      fontSize: FontSize.s16,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.w,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final items = [
      _DrawerItem(
        icon: Icons.person_outline,
        label: AppStrings.driverProfile,
        route: Routes.driverProfile,
      ),
      _DrawerItem(
        icon: Icons.headset_mic_outlined,
        label: AppStrings.supportTeam,
        route: Routes.driverSupport,
      ),
      _DrawerItem(
        icon: Icons.bar_chart_outlined,
        label: AppStrings.reports,
        route: Routes.driverReports,
      ),
      _DrawerItem(
        icon: Icons.receipt_long_outlined,
        label: AppStrings.recentOrders,
        route: Routes.driverOrders,
      ),
      _DrawerItem(
        icon: Icons.privacy_tip_outlined,
        label: AppStrings.privacyPolicy,
        route: Routes.driverPrivacyPolicy,
      ),
    ];

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: Insets.s8),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        color: AppColors.divider,
        height: 1,
        indent: Insets.s16,
        endIndent: Insets.s16,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return ListTile(
          leading: Icon(
            item.icon,
            size: 24.w,
            color: AppColors.darkGrey,
          ),
          title: Text(
            item.label,
            style: getMediumStyle(
              color: AppColors.darkGrey,
              fontSize: FontSize.s14,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.w,
            color: AppColors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16),
          onTap: () {
            Navigator.of(context).pop(); // close drawer
            Navigator.of(context).pushNamed(item.route);
          },
        );
      },
    );
  }

  Widget _buildLogout(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.logout_rounded,
        size: 24.w,
        color: AppColors.error,
      ),
      title: Text(
        AppStrings.logout,
        style: getMediumStyle(
          color: AppColors.error,
          fontSize: FontSize.s14,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16),
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.login,
          (_) => false,
        );
      },
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final String route;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
