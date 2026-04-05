import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/token_storage.dart';

class DriverDrawer extends StatelessWidget {
  const DriverDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = sl<TokenStorage>().getUser();
    final driverName = (user?['name'] as String?) ?? 'السائق';

    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: Sizes.s16),

            // ── Driver profile header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.primary50,
                    child: Icon(
                      Icons.person,
                      size: 32.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: Insets.s12),
                  // Name, role, rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName,
                          style: getBoldStyle(
                            fontSize: FontSize.s16,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          AppStrings.towDriver,
                          style: getRegularStyle(
                            fontSize: FontSize.s14,
                            color: AppColors.grey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16.sp,
                              color: AppColors.gold,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '4.9 (541)',
                              style: getMediumStyle(
                                fontSize: FontSize.s12,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Sizes.s20),

            // ── Wallet card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to wallet when route is available
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s16,
                    vertical: Insets.s12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 22.sp,
                        color: AppColors.white,
                      ),
                      SizedBox(width: Insets.s12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.wallet,
                            style: getRegularStyle(
                              fontSize: FontSize.s12,
                              color: AppColors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'EGP 1,320',
                            style: getBoldStyle(
                              fontSize: FontSize.s18,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: Sizes.s24),

            // ── Menu items ──
            const Divider(color: AppColors.divider, height: 1),

            _DrawerMenuItem(
              icon: Icons.person_outline_rounded,
              title: AppStrings.driverProfile,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverProfile);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.headset_mic_outlined,
              title: AppStrings.supportTeam,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverSupport);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.bar_chart_rounded,
              title: AppStrings.reports,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverReports);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.receipt_long_outlined,
              title: AppStrings.recentOrders,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverOrders);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: AppStrings.privacyPolicy,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverPrivacyPolicy);
              },
            ),

            const Spacer(),

            // ── Logout ──
            const Divider(color: AppColors.divider, height: 1),
            _DrawerMenuItem(
              icon: Icons.logout_rounded,
              title: AppStrings.logout,
              color: AppColors.error,
              onTap: () async {
                Navigator.pop(context); // close drawer
                await sl<TokenStorage>().clearAll();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.login,
                    (route) => false,
                  );
                }
              },
            ),
            SizedBox(height: Sizes.s16),
          ],
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.black;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s12,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: itemColor),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Text(
                title,
                style: getMediumStyle(
                  fontSize: FontSize.s16,
                  color: itemColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
