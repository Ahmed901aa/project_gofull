import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import '../widgets/confirmation_dialog.dart';
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
  final _nameController = TextEditingController(text: 'Ahmed Elamrity');
  final _phoneController = TextEditingController(text: '0915909734');
  bool _phoneVerified = true;
  String _savedPhone = '0915909734';

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التغييرات')),
    );
    Navigator.pop(context);
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        icon: Icons.person_remove_outlined,
        iconColor: const Color(0xFFE63946),
        title: 'حذف الحساب؟',
        subtitle: 'حذف الحساب يعني خسارة جميع بياناتك، سجل طلباتك. هل أنت متأكد؟',
        confirmLabel: 'تأكيد الحذف',
        onConfirm: () {
          Navigator.pop(context);
          // TODO: handle delete account logic
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            const AppHeader(title: 'تعديل بيانات الحساب'),
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
      ),
    );
  }
}
