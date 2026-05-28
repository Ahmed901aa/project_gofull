import 'package:flutter/material.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import '../widgets/edit_profile_avatar.dart';
import '../widgets/edit_profile_bottom_buttons.dart';
import '../widgets/edit_profile_fields.dart';
import '../widgets/phone_otp_bottom_sheet.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _phoneVerified = true;
  late String _savedPhone;

  @override
  void initState() {
    super.initState();
    final user = sl<TokenStorage>().getUser();
    final name = (user?['name'] as String?) ?? '';
    final phone = (user?['phone'] as String?) ?? '';
    _nameController = TextEditingController(text: name);
    _phoneController = TextEditingController(text: phone);
    _savedPhone = phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    setState(() => _phoneVerified = value == _savedPhone);
  }

  Future<void> _verifyPhone() async {
    final result = await PhoneOtpBottomSheet.show(context, _phoneController.text);
    if (result == true && mounted) {
      setState(() {
        _phoneVerified = true;
        _savedPhone = _phoneController.text;
      });
    }
  }

  void _saveChanges() {
    final l10n = S.of(context);
    AppSnackbar.success(context, l10n.changesSaved);
    Navigator.pop(context);
  }

  void _deleteAccount() async {
    final l10n = S.of(context);
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.person_remove_outlined,
      iconColor: AppColors.error,
      title: l10n.deleteAccount,
      subtitle: l10n.deleteAccountSubtitle,
      confirmLabel: l10n.confirmDelete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (confirmed) {
      // TODO: handle delete account logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            AppHeader(title: S.of(context).editProfile),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const EditProfileAvatar(),
                    SizedBox(height: Insets.s12),
                    NameField(controller: _nameController),
                    SizedBox(height: Insets.s16),
                    PhoneField(
                      controller: _phoneController,
                      verified: _phoneVerified,
                      onChanged: _onPhoneChanged,
                      onVerifyTap: _verifyPhone,
                    ),
                  ],
                ),
              ),
            ),
            EditProfileBottomButtons(onSave: _saveChanges, onDelete: _deleteAccount),
          ],
        ),
      );
  }
}
