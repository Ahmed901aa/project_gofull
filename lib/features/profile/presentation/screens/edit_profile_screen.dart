import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import '../widgets/edit_profile_avatar.dart';
import '../widgets/edit_profile_bottom_buttons.dart';
import '../widgets/edit_profile_fields.dart';
import '../widgets/phone_otp_bottom_sheet.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
  late String _savedName;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = sl<TokenStorage>().getUser();
    final name = (user?['name'] as String?) ?? '';
    final phone = (user?['phone'] as String?) ?? '';
    _nameController = TextEditingController(text: name);
    _phoneController = TextEditingController(text: phone);
    _savedPhone = phone;
    _savedName = name;
    _nameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    // Trigger rebuild so dirty state updates the button
    setState(() {});
  }

  bool get _isDirty {
    return _nameController.text.trim() != _savedName ||
        _phoneController.text.trim() != _savedPhone;
  }

  bool get _isValid {
    return _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _phoneVerified;
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

  Future<void> _saveChanges() async {
    if (_saving || !_isDirty || !_isValid) return;

    final l10n = S.of(context);
    setState(() => _saving = true);

    try {
      final apiClient = sl<ApiClient>();
      final tokenStorage = sl<TokenStorage>();

      final response = await apiClient.dio.put(
        ApiConstants.profile,
        data: {
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );

      if (!mounted) return;

      // Update local storage with new values
      final currentUser = tokenStorage.getUser() ?? {};
      currentUser['name'] = _nameController.text.trim();
      currentUser['phone'] = _phoneController.text.trim();

      // If backend returns updated user data, use that instead
      final responseData = response.data as Map<String, dynamic>?;
      if (responseData != null && responseData['data'] is Map) {
        final userData = responseData['data'] as Map<String, dynamic>;
        if (userData['name'] != null) currentUser['name'] = userData['name'];
        if (userData['phone'] != null) currentUser['phone'] = userData['phone'];
      }

      await tokenStorage.saveUser(currentUser);

      // Update saved state
      _savedName = _nameController.text.trim();
      _savedPhone = _phoneController.text.trim();

      setState(() => _saving = false);
      AppSnackbar.success(context, l10n.changesSaved);
      Navigator.pop(context);
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      final msg = (e.response?.data as Map<String, dynamic>?)?['message'] as String?;
      AppSnackbar.error(context, msg ?? l10n.somethingWentWrong);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      AppSnackbar.error(context, l10n.somethingWentWrong);
    }
  }

  void _deleteAccount() async {
    final l10n = S.of(context);
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.person_remove_outlined,
      iconColor: context.colors.error,
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
        backgroundColor: context.colors.background,
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
            EditProfileBottomButtons(
              onSave: _saveChanges,
              onDelete: _deleteAccount,
              saveEnabled: _isDirty && _isValid && !_saving,
              saving: _saving,
            ),
          ],
        ),
      );
  }
}
