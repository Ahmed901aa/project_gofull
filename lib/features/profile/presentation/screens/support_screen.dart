import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),
                      SvgPicture.asset(
                        'assets/svg/help_user.svg',
                        width: 200.w,
                        height: 200.w,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'كيف يمكننا مساعدتك؟',
                        style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'فريق الدعم الفني متاح لمساعدتك على مدار الساعة',
                        style: getRegularStyle(
                          color: const Color(0xFF646565),
                          fontSize: FontSize.s14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      GestureDetector(
                        onTap: _makeCall,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(Insets.s16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.s16),
                            border: Border.all(color: const Color(0xFFEFF0F1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.phone_rounded,
                                  size: 22.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'اتصال مباشر',
                                      style: getBoldStyle(
                                        color: const Color(0xFF0E0E0E),
                                        fontSize: FontSize.s16,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'رقم الجوال: $_phoneNumber',
                                      style: getRegularStyle(
                                        color: const Color(0xFF646565),
                                        fontSize: FontSize.s14,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Insets.s24),
                    ],
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
                    'الدعم الفني',
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
