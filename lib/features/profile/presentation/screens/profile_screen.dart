import 'package:flutter/material.dart';
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
import '../widgets/confirmation_dialog.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_user_card.dart';

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

  String _serviceTypeLabel(String? type) {
    switch (type) {
      case 'fuel_delivery':
        return 'توصيل وقود';
      case 'towing':
        return 'سحب مركبات';
      default:
        return type ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use API data first, fall back to cached token data
    final userName = (_profileData?['name'] as String?) ??
        (sl<TokenStorage>().getUser()?['name'] as String?) ??
        'المستخدم';
    final userPhone = (_profileData?['phone'] as String?) ??
        (sl<TokenStorage>().getUser()?['phone'] as String?) ??
        '';
    final userRole = (_profileData?['role'] as String?) ??
        (sl<TokenStorage>().getUser()?['role'] as String?) ??
        'driver';
    final initials = userName.isNotEmpty ? userName[0] : '؟';
    final isProvider = userRole == 'provider';

    final completedOrders = int.tryParse('${_profileData?['completed_orders'] ?? ''}') ?? 0;
    final averageRating = double.tryParse('${_profileData?['average_rating'] ?? ''}') ?? 0.0;
    final totalRatings = int.tryParse('${_profileData?['total_ratings'] ?? ''}') ?? 0;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const AppHeader(title: 'حسابي', showBack: false),
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
                          _profileData?['service_type'] as String?),
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
                  // ── Stats: Rating & Completed Orders ──
                  if (!_isLoading)
                    _ProfileStatsRow(
                      averageRating: averageRating,
                      totalRatings: totalRatings,
                      completedOrders: completedOrders,
                    ),
                  if (!_isLoading) SizedBox(height: Insets.s16),
                  ProfileMenuItem(
                    icon: Icons.local_offer_outlined,
                    label: 'أكواد الخصم',
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.discountCodes),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.language_rounded,
                    label: 'اللغة',
                    trailing: 'English',
                    onTap: () {},
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.headset_mic_outlined,
                    label: 'الدعم الفني',
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.support),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'الأسئلة الشائعة',
                    onTap: () => Navigator.pushNamed(context, Routes.faq),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.description_outlined,
                    label: 'الشروط والأحكام',
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.terms),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'سياسة الخصوصية',
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.privacyPolicy),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'عن Go Full',
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.aboutApp),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    label: 'تسجيل الخروج',
                    iconColor: AppColors.error,
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationDialog(
        icon: Icons.logout_rounded,
        iconColor: AppColors.primary,
        title: 'تسجيل الخروج؟',
        subtitle:
            'متأكد إنك عاوز تخرج من حسابك؟ تقدر ترجع لنا في أي وقت وتكمل توفير.',
        confirmLabel: 'تسجيل الخروج',
        onConfirm: () async {
          Navigator.pop(dialogCtx); // close dialog
          await sl<TokenStorage>().clearAll();
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil(Routes.login, (r) => false);
          }
        },
      ),
    );
  }
}

// ── Stats Row Widget ────────────────────────────────────────

class _ProfileStatsRow extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final int completedOrders;

  const _ProfileStatsRow({
    required this.averageRating,
    required this.totalRatings,
    required this.completedOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _statBox('التقييم', averageRating > 0 ? averageRating.toStringAsFixed(1) : '-', Icons.star_rounded, AppColors.gold)),
        SizedBox(width: Insets.s8),
        Expanded(child: _statBox('التقييمات', '$totalRatings', Icons.reviews_rounded, AppColors.info)),
        SizedBox(width: Insets.s8),
        Expanded(child: _statBox('المكتملة', '$completedOrders', Icons.check_circle_rounded, AppColors.success)),
      ],
    );
  }

  Widget _statBox(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Insets.s12, horizontal: Insets.s8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22.sp, color: iconColor),
          SizedBox(height: 6.h),
          Text(
            value,
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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

  String _statusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'موثق';
      case 'pending':
        return 'قيد المراجعة';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: service type + status badges
          Row(
            children: [
              Icon(
                serviceType == 'سحب مركبات'
                    ? Icons.car_crash_rounded
                    : Icons.local_gas_station_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                serviceType,
                style: getBoldStyle(
                    color: AppColors.primary, fontSize: FontSize.s14),
              ),
              const Spacer(),
              // Verification badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor(verificationStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Text(
                  _statusLabel(verificationStatus),
                  style: getBoldStyle(
                    color: _statusColor(verificationStatus),
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
                  color: (isAvailable ? AppColors.success : AppColors.grey)
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
                            isAvailable ? AppColors.success : AppColors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isAvailable ? 'متاح' : 'غير متاح',
                      style: getBoldStyle(
                        color:
                            isAvailable ? AppColors.success : AppColors.grey,
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
          _infoRow(Icons.directions_car_rounded, 'المركبة',
              '$vehicleMake $vehicleModel'),
          SizedBox(height: 8.h),
          _infoRow(Icons.confirmation_number_rounded, 'اللوحة', vehiclePlate),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.grey),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: getRegularStyle(
              color: AppColors.grey, fontSize: FontSize.s12),
        ),
        Expanded(
          child: Text(
            value,
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s12),
          ),
        ),
      ],
    );
  }
}
