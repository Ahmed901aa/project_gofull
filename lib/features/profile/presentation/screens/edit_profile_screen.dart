import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import '../widgets/confirmation_dialog.dart';
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
    setState(() {
      _phoneVerified = value == _savedPhone;
    });
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
    // replace with API later
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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAvatar(),
                    SizedBox(height: Insets.s12),
                    _buildNameField(),
                    SizedBox(height: Insets.s16),
                    _buildPhoneField(),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'تعديل بيانات الحساب',
                      style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildAvatar() => Center(
        child: SizedBox(
          width: 104.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 52.w,
                backgroundColor: AppColors.neutral500,
                child: Icon(Icons.person, size: 52.sp, color: const Color(0xFF838485)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () {
                    // replace with image picker later
                  },
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(AppRadius.s16),
                      border: Border.all(color: const Color(0xFFEFF0F1)),
                    ),
                    child: Icon(Icons.edit_outlined, size: 12.sp, color: const Color(0xFF0E0E0E)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildNameField() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'الاسم بالكامل',
            style: getBoldStyle(color: const Color(0xFF252525), fontSize: FontSize.s16).copyWith(height: 1.4),
          ),
          SizedBox(height: Insets.s8),
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F9),
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: const Color(0xFFEFF0F1)),
            ),
            alignment: Alignment.centerRight,
            child: TextField(
              controller: _nameController,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.4),
            ),
          ),
        ],
      );

  Widget _buildPhoneField() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'رقم الجوال',
            style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16).copyWith(height: 1.4),
          ),
          SizedBox(height: Insets.s8),
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F9),
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: const Color(0xFFEFF0F1)),
            ),
            child: Row(
              children: [
                // Flag + country code (RIGHT in RTL)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🇱🇾', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: Insets.s8),
                    Text(
                      '+218',
                      style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s16).copyWith(height: 1.6),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 16.sp, color: const Color(0xFF838485)),
                  ],
                ),
                Container(width: 1, height: 24.h, color: const Color(0xFFD9DADB), margin: EdgeInsets.symmetric(horizontal: 3.w)),
                // Phone input
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.4),
                    onChanged: _onPhoneChanged,
                  ),
                ),
                SizedBox(width: Insets.s8),
                // Verified checkmark or confirm button (LEFT in RTL)
                if (_phoneVerified)
                  Icon(Icons.check_circle, size: 20.sp, color: const Color(0xFF2D6A4F))
                else
                  GestureDetector(
                    onTap: _verifyPhone,
                    child: Text(
                      'تأكيد الرقم',
                      style: getBoldStyle(color: const Color(0xFF004B3B), fontSize: FontSize.s14).copyWith(height: 1.6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );

  Widget _buildBottomButtons(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          border: Border.all(color: const Color(0xFFF8F8F9)),
          boxShadow: const [
            BoxShadow(color: Color(0x05CCCCCC), blurRadius: 1, offset: Offset(0, -1)),
            BoxShadow(color: Color(0x05CCCCCC), blurRadius: 2, offset: Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              children: [
                // Save changes (RIGHT in RTL — takes remaining space)
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004B3B),
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'حفظ التغييرات',
                        style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16).copyWith(height: 1.6),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Insets.s12),
                // Delete account (LEFT in RTL — fixed width)
                SizedBox(
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: _deleteAccount,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBE1E3),
                      foregroundColor: const Color(0xFFE63946),
                      side: const BorderSide(color: Color(0xFFE63946)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                    ),
                    child: Text(
                      'حذف الحساب',
                      style: getBoldStyle(color: const Color(0xFFE63946), fontSize: FontSize.s16).copyWith(height: 1.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
