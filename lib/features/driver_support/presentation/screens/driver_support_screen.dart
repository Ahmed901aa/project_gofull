import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverSupportScreen extends StatefulWidget {
  const DriverSupportScreen({super.key});

  @override
  State<DriverSupportScreen> createState() => _DriverSupportScreenState();
}

class _DriverSupportScreenState extends State<DriverSupportScreen> {
  final _phoneController = TextEditingController(text: '0915909734');
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _makeCall() async {
    final uri = Uri(scheme: 'tel', path: '0915909734');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.technicalSupport,
          style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: const Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Insets.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Direct call section
            Text(
              AppStrings.directCall,
              style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s18),
            ),
            SizedBox(height: Sizes.s12),
            Container(
              padding: EdgeInsets.all(Insets.s16),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppRadius.s12),
                border: Border.all(color: AppColors.neutral300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.phoneNumber,
                          style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
                        ),
                        SizedBox(height: Sizes.s8),
                        Text(
                          '0915909734',
                          style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s18),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _makeCall,
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.s12),
                      ),
                      child: Icon(
                        Icons.phone,
                        color: AppColors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Sizes.s32),

            // Send inquiry section
            Text(
              AppStrings.send,
              style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s18),
            ),
            SizedBox(height: Sizes.s8),
            Text(
              AppStrings.inquiryDesc,
              style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
            ),
            SizedBox(height: Sizes.s16),

            // Phone field
            Text(
              AppStrings.phoneNumber,
              style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
            ),
            SizedBox(height: Sizes.s8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: getRegularStyle(color: AppColors.black, fontSize: FontSize.s16),
              decoration: InputDecoration(
                hintText: AppStrings.phoneHint,
                hintStyle: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
                filled: true,
                fillColor: AppColors.neutral50,
                contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Sizes.s12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(height: Sizes.s16),

            // Notes field
            Text(
              AppStrings.addNotes,
              style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
            ),
            SizedBox(height: Sizes.s8),
            TextField(
              controller: _notesController,
              maxLines: 5,
              style: getRegularStyle(color: AppColors.black, fontSize: FontSize.s16),
              decoration: InputDecoration(
                hintText: AppStrings.addNotesHint,
                hintStyle: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
                filled: true,
                fillColor: AppColors.neutral50,
                contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Sizes.s12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            SizedBox(height: Sizes.s24),

            AppButton(
              text: AppStrings.send,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال الاستفسار بنجاح')),
                );
                _notesController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
