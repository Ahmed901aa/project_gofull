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

  @override
  Widget build(BuildContext context) {
    final tokenStorage = sl<TokenStorage>();
    final user = tokenStorage.getUser();
    final userName = (user?['name'] as String?) ?? 'المستخدم';
    final userPhone = (user?['phone'] as String?) ?? '';
    final initials = userName.isNotEmpty ? userName[0] : '؟';

    final completedOrders = _profileData?['completed_orders'] as int? ?? 0;
    final averageRating = (_profileData?['average_rating'] as num?)?.toDouble() ?? 0.0;
    final totalRatings = _profileData?['total_ratings'] as int? ?? 0;

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
