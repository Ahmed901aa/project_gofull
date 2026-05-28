import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/token_storage.dart';

class DriverDrawer extends StatefulWidget {
  const DriverDrawer({super.key});

  @override
  State<DriverDrawer> createState() => _DriverDrawerState();
}

class _DriverDrawerState extends State<DriverDrawer> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final response =
          await sl<ApiClient>().dio.get(ApiConstants.providerProfile);
      if (mounted) {
        setState(() {
          _profileData = response.data['data'] as Map<String, dynamic>?;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _serviceTypeLabel(String? type, BuildContext context) {
    switch (type) {
      case 'fuel_delivery':
        return S.of(context).fuelDeliveryDriver;
      case 'towing':
        return S.of(context).towTruckDriverRole;
      default:
        return type ?? S.of(context).towDriver;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use API data first, fall back to cached token
    final user = sl<TokenStorage>().getUser();
    final driverName =
        (_profileData?['name'] as String?) ??
        (user?['name'] as String?) ??
        S.of(context).theDriver;
    final serviceType = _serviceTypeLabel(
        _profileData?['service_type'] as String?, context);
    final averageRating =
        double.tryParse('${_profileData?['average_rating'] ?? ''}') ?? 0.0;
    final totalRatings =
        int.tryParse('${_profileData?['total_ratings'] ?? ''}') ?? 0;
    final totalIncome =
        double.tryParse('${_profileData?['total_income'] ?? ''}') ?? 0.0;
    final initials = driverName.isNotEmpty ? driverName[0] : '؟';

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
                    child: Text(
                      initials,
                      style: getBoldStyle(
                        fontSize: FontSize.s20,
                        color: AppColors.primary,
                      ),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          serviceType,
                          style: getRegularStyle(
                            fontSize: FontSize.s14,
                            color: AppColors.grey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        if (_isLoading)
                          SizedBox(
                            width: 60.w,
                            height: 12.h,
                            child: const LinearProgressIndicator(
                              backgroundColor: AppColors.neutral500,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary200),
                            ),
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16.sp,
                                color: AppColors.gold,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                averageRating > 0
                                    ? '${averageRating.toStringAsFixed(1)} ($totalRatings)'
                                    : '— (0)',
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

            // ── Menu items ──
            const Divider(color: AppColors.divider, height: 1),

            _DrawerMenuItem(
              icon: Icons.person_outline_rounded,
              title: S.of(context).driverProfile,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverProfile);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.headset_mic_outlined,
              title: S.of(context).supportTeam,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverSupport);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.bar_chart_rounded,
              title: S.of(context).reports,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverReports);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.receipt_long_outlined,
              title: S.of(context).recentOrders,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.driverOrders);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: S.of(context).privacyPolicy,
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
              title: S.of(context).logout,
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
              Icons.arrow_forward_rounded,
              size: 14.sp,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
