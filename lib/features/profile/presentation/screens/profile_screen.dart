import 'package:flutter/material.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_user_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenStorage = sl<TokenStorage>();
    final user = tokenStorage.getUser();
    final userName = (user?['name'] as String?) ?? 'المستخدم';
    final userPhone = (user?['phone'] as String?) ?? '';
    final initials = userName.isNotEmpty ? userName[0] : '؟';

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
