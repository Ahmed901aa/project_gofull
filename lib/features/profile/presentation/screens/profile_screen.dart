import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:project_gofull/features/profile/presentation/widgets/confirmation_dialog.dart';
import 'package:project_gofull/features/profile/presentation/widgets/profile_user_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // replace with API data later
                  ProfileUserCard(
                    name: 'احمد احميد',
                    phone: '0915909734',
                    initials: 'أ . ل',
                    onEdit: () => Navigator.pushNamed(context, Routes.editProfile),
                  ),
                  SizedBox(height: Insets.s16),
                  ProfileMenuItem(
                    icon: Icons.local_offer_outlined,
                    label: 'أكواد الخصم',
                    onTap: () => Navigator.pushNamed(context, Routes.discountCodes),
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
                    onTap: () => Navigator.pushNamed(context, Routes.support),
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
                    onTap: () => Navigator.pushNamed(context, Routes.terms),
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'سياسة الخصوصية',
                    onTap: () {},
                  ),
                  SizedBox(height: Sizes.s12),
                  ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'عن Go Full',
                    onTap: () {},
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
      builder: (_) => ConfirmationDialog(
        icon: Icons.logout_rounded,
        iconColor: AppColors.primary,
        title: 'تسجيل الخروج؟',
        subtitle: 'متأكد إنك عاوز تخرج من حسابك؟ تقدر ترجع لنا في أي وقت وتكمل توفير.',
        confirmLabel: 'تسجيل الخروج',
        onConfirm: () {
          Navigator.pop(context);
          // TODO: handle logout logic
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Center(
                child: Text(
                  'حسابي',
                  style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );
}
