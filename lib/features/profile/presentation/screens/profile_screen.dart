import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/core/cubits/locale_cubit.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/core/widgets/language_selector_sheet.dart';
import 'package:project_gofull/core/widgets/theme_selector_sheet.dart';
import 'package:project_gofull/core/cubits/theme_cubit.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_user_card.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await sl<ApiClient>().dio.get(ApiConstants.profile);
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

  String _serviceTypeLabel(String? type, S l10n) {
    switch (type) {
      case 'fuel_delivery':
        return l10n.fuelDelivery;
      case 'towing':
        return l10n.towingService;
      default:
        return type ?? '-';
    }
  }

  String _themeTrailing(BuildContext context) {
    final l10n = S.of(context);
    final mode = context.watch<ThemeCubit>().appThemeMode;
    switch (mode) {
      case AppThemeMode.system:
        return l10n.themeSystem;
      case AppThemeMode.light:
        return l10n.themeLight;
      case AppThemeMode.dark:
        return l10n.themeDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final localeCubit = context.watch<LocaleCubit>();
    // Use API data first, fall back to cached token data
    final userName = (_profileData?['name'] as String?) ??
        (sl<TokenStorage>().getUser()?['name'] as String?) ??
        l10n.appName;
    final userPhone = (_profileData?['phone'] as String?) ??
        (sl<TokenStorage>().getUser()?['phone'] as String?) ??
        '';
    final userRole = (_profileData?['role'] as String?) ??
        (sl<TokenStorage>().getUser()?['role'] as String?) ??
        'driver';
    final initials = userName.isNotEmpty ? userName[0] : '?';
    final isProvider = userRole == 'provider';

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          AppHeader(title: l10n.myAccount, showBack: false),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileUserCard(
                    name: userName,
                    phone: userPhone,
                    initials: initials,
                    onEdit: () =>
                        Navigator.pushNamed(context, Routes.editProfile),
                  ),
                  SizedBox(height: Insets.s16),
                  // ── Provider Info Card ──
                  if (!_isLoading && isProvider)
                    _ProviderInfoSection(
                      serviceType: _serviceTypeLabel(
                          _profileData?['service_type'] as String?, l10n),
                      vehicleMake:
                          _profileData?['vehicle_make'] as String? ?? '-',
                      vehicleModel:
                          _profileData?['vehicle_model'] as String? ?? '-',
                      vehiclePlate:
                          _profileData?['vehicle_plate'] as String? ?? '-',
                      isAvailable:
                          _profileData?['is_available'] as bool? ?? false,
                      verificationStatus:
                          _profileData?['verification_status'] as String? ??
                              'pending',
                    ),
                  if (!_isLoading && isProvider) SizedBox(height: Insets.s16),
                  SizedBox(height: Insets.s16),
                  ProfileMenuItem(
                    icon: Icons.local_offer_outlined,
                    label: l10n.discountCodes,
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.discountCodes),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.language_rounded,
                    label: l10n.language,
                    trailing: localeCubit.isArabic ? 'English' : l10n.arabic,
                    onTap: () async {
                      final changed = await showLanguageSelectorSheet(context);
                      if (changed && mounted) {
                        AppSnackbar.success(context, l10n.languageChanged);
                      }
                    },
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.brightness_6_rounded,
                    label: l10n.appearance,
                    trailing: _themeTrailing(context),
                    onTap: () async {
                      final changed = await showThemeSelectorSheet(context);
                      if (changed && mounted) {
                        AppSnackbar.success(context, l10n.themeChanged);
                      }
                    },
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.headset_mic_outlined,
                    label: l10n.technicalSupport,
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.support),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    label: l10n.faq,
                    onTap: () => Navigator.pushNamed(context, Routes.faq),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.description_outlined,
                    label: l10n.terms,
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.terms),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: l10n.privacyPolicy,
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.privacyPolicy),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: l10n.aboutGoFull,
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.aboutApp),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    label: l10n.logout,
                    iconColor: context.colors.error,
                    onTap: () => _showLogoutDialog(context),
                  ),
                  SizedBox(height: Sizes.s16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    final l10n = S.of(context);
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.logout_rounded,
      iconColor: context.colors.warning,
      title: l10n.logoutTitle,
      subtitle: l10n.logoutSubtitle,
      confirmLabel: l10n.logoutBtn,
      cancelLabel: l10n.stayBtn,
      destructive: true,
    );
    if (confirmed && context.mounted) {
      await sl<TokenStorage>().clearAll();
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(Routes.login, (r) => false);
      }
    }
  }
}

// ── Provider Info Section ───────────────────────────────────

class _ProviderInfoSection extends StatelessWidget {
  final String serviceType;
  final String vehicleMake;
  final String vehicleModel;
  final String vehiclePlate;
  final bool isAvailable;
  final String verificationStatus;

  const _ProviderInfoSection({
    required this.serviceType,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.isAvailable,
    required this.verificationStatus,
  });

  String _statusLabel(BuildContext context, String status) {
    final l10n = S.of(context);
    switch (status) {
      case 'approved':
        return l10n.verified;
      case 'pending':
        return l10n.pendingReview;
      case 'rejected':
        return l10n.rejected;
      default:
        return status;
    }
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'approved':
        return context.colors.success;
      case 'pending':
        return context.colors.warning;
      case 'rejected':
        return context.colors.error;
      default:
        return context.colors.iconSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: service type + status badges
          Row(
            children: [
              Icon(
                serviceType == l10n.towingService
                    ? Icons.car_crash_rounded
                    : Icons.local_gas_station_rounded,
                color: context.colors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  serviceType,
                  style: getBoldStyle(
                      color: context.colors.primary, fontSize: FontSize.s14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              // Verification badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor(context, verificationStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Text(
                  _statusLabel(context, verificationStatus),
                  style: getBoldStyle(
                    color: _statusColor(context, verificationStatus),
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              // Availability badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (isAvailable ? context.colors.success : context.colors.iconSecondary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color:
                            isAvailable ? context.colors.success : context.colors.iconSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isAvailable ? l10n.available : l10n.unavailable,
                      style: getBoldStyle(
                        color:
                            isAvailable ? context.colors.success : context.colors.iconSecondary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s12),
          // Vehicle info
          _infoRow(context, Icons.directions_car_rounded, l10n.vehicleInfo,
              '$vehicleMake $vehicleModel'),
          SizedBox(height: 8.h),
          _infoRow(context, Icons.confirmation_number_rounded, l10n.carPlate, vehiclePlate),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: context.colors.iconSecondary),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: getRegularStyle(
              color: context.colors.iconSecondary, fontSize: FontSize.s12),
        ),
        Expanded(
          child: Text(
            value,
            style: getBoldStyle(
                color: context.colors.textPrimary, fontSize: FontSize.s12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
