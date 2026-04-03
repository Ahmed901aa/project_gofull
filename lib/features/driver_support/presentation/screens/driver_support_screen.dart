import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverSupportScreen extends StatefulWidget {
  const DriverSupportScreen({super.key});

  @override
  State<DriverSupportScreen> createState() => _DriverSupportScreenState();
}

class _DriverSupportScreenState extends State<DriverSupportScreen> {
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  static const _maxNotes = 80;
  static const _supportPhone = '+96545345368';

  @override
  void dispose() {
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _callSupport() async {
    final uri = Uri.parse('tel:$_supportPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _copyPhone() {
    Clipboard.setData(const ClipboardData(text: _supportPhone));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم نسخ الرقم',
          style: getRegularStyle(color: AppColors.white, fontSize: FontSize.s14),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitInquiry() {
    // replace with API call
    if (_notesController.text.trim().isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إرسال استفسارك بنجاح',
          style: getRegularStyle(color: AppColors.white, fontSize: FontSize.s14),
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
    _phoneController.clear();
    _notesController.clear();
    setState(() {});
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
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Illustration placeholder
                    _SupportIllustration(),
                    SizedBox(height: Insets.s24),

                    // ── Direct Call Section ──
                    _DirectCallSection(
                      onCall: _callSupport,
                      onCopy: _copyPhone,
                    ),
                    SizedBox(height: Insets.s24),

                    // ── Inquiry Form Section ──
                    _InquiryFormSection(
                      phoneController: _phoneController,
                      notesController: _notesController,
                      maxNotes: _maxNotes,
                      onNotesChanged: () => setState(() {}),
                      onSubmit: _submitInquiry,
                    ),

                    SizedBox(height: Insets.s32),
                  ],
                ),
              ),
            ),
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
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'الدعم الفني',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
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
}

// ── Illustration ─────────────────────────────────────────

class _SupportIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.s24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.headset_mic_rounded,
                size: 56.sp, color: AppColors.primary),
            SizedBox(height: Insets.s8),
            Text(
              'فريق الدعم متاح لمساعدتك',
              style: getMediumStyle(
                  color: AppColors.primary, fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Direct Call Section ──────────────────────────────────

class _DirectCallSection extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onCopy;

  const _DirectCallSection({required this.onCall, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'اتصال مباشر',
          style: getBoldStyle(
              color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Row(
            children: [
              // Phone icon
              GestureDetector(
                onTap: onCall,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.phone_rounded,
                      size: 22.sp, color: AppColors.white),
                ),
              ),
              SizedBox(width: Insets.s12),
              // Label + number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم الجوال:',
                      style: getRegularStyle(
                          color: AppColors.grey, fontSize: FontSize.s12),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '+965 4534 5368',
                      style: getSemiBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s16),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              // Copy icon
              GestureDetector(
                onTap: onCopy,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.neutral400,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.copy_rounded,
                      size: 18.sp, color: AppColors.darkGrey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Inquiry Form Section ─────────────────────────────────

class _InquiryFormSection extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController notesController;
  final int maxNotes;
  final VoidCallback onNotesChanged;
  final VoidCallback onSubmit;

  const _InquiryFormSection({
    required this.phoneController,
    required this.notesController,
    required this.maxNotes,
    required this.onNotesChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Description
        Text(
          'يمكنك أيضاً تفاصيل استفسارات أو الشكوى، وسنقوم بالرد عليك في أقرب وقت ممكن.',
          style: getRegularStyle(
              color: AppColors.darkGrey, fontSize: FontSize.s14)
              .copyWith(height: 1.6),
        ),
        SizedBox(height: Insets.s16),

        // Phone input
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            children: [
              // Country code
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s12, vertical: Insets.s12),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.inputBorder, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '965+',
                      style: getMediumStyle(
                          color: AppColors.black, fontSize: FontSize.s16),
                    ),
                    SizedBox(width: 6.w),
                    Text('🇰🇼', style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
              ),
              // Phone input field
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  style: getMediumStyle(
                      color: AppColors.black, fontSize: FontSize.s16),
                  decoration: InputDecoration(
                    hintText: 'أدخل رقم الجوال',
                    hintStyle: getRegularStyle(
                        color: AppColors.grey, fontSize: FontSize.s16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Insets.s12, vertical: Insets.s12),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Insets.s16),

        // Notes text area
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: notesController,
                maxLines: 4,
                maxLength: maxNotes,
                onChanged: (_) => onNotesChanged(),
                style: getMediumStyle(
                    color: AppColors.black, fontSize: FontSize.s14),
                decoration: InputDecoration(
                  hintText: 'اكتب هنا أي تفاصيل إضافية تود مشاركتها...',
                  hintStyle: getRegularStyle(
                      color: AppColors.grey, fontSize: FontSize.s14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(Insets.s12),
                  counterText: '',
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    Insets.s12, 0, Insets.s12, Insets.s8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${notesController.text.length}/$maxNotes',
                    style: getRegularStyle(
                        color: AppColors.grey, fontSize: FontSize.s12),
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Insets.s20),

        // Submit button
        AppButton(
          text: 'إرسال',
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
