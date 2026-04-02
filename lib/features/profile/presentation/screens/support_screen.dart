import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _phoneNumber = '0915909734';

  Future<void> _makeCall() async {
    final uri = Uri(scheme: 'tel', path: _phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.s24,
                      vertical: Insets.s32,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.s24),
                      border: Border.all(color: const Color(0xFFEFF0F1)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.headset_mic_outlined,
                            size: 32.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: Insets.s16),
                        Text(
                          'تواصل معنا',
                          style: getBoldStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s20,
                          ),
                        ),
                        SizedBox(height: Insets.s8),
                        Text(
                          'للمساعدة والدعم الفني',
                          style: getRegularStyle(
                            color: const Color(0xFF838485),
                            fontSize: FontSize.s14,
                          ),
                        ),
                        SizedBox(height: Insets.s24),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: Insets.s16,
                            vertical: Insets.s12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F9),
                            borderRadius: BorderRadius.circular(AppRadius.s16),
                            border: Border.all(color: const Color(0xFFEFF0F1)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 20.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: Insets.s12),
                              Expanded(
                                child: Text(
                                  _phoneNumber,
                                  style: getMediumStyle(
                                    color: const Color(0xFF0E0E0E),
                                    fontSize: FontSize.s16,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Insets.s16),
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton.icon(
                            onPressed: _makeCall,
                            icon: Icon(Icons.call_rounded, size: 20.sp),
                            label: Text(
                              'اتصل بنا',
                              style: getBoldStyle(
                                color: AppColors.white,
                                fontSize: FontSize.s16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.s16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 24.sp,
                      color: const Color(0xFF0E0E0E),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox.shrink(),
                  ),
                  Text(
                    'الدعم والمساعدة',
                    style: getBoldStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: FontSize.s20,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox.shrink(),
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
