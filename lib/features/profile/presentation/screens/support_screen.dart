import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/support_phone_card.dart';

class SupportScreen extends StatelessWidget {
  final bool showBack;
  const SupportScreen({super.key, this.showBack = true});

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
            AppHeader(title: 'الدعم الفني', showBack: showBack),
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
                      SupportPhoneCard(
                        phoneNumber: _phoneNumber,
                        onTap: _makeCall,
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
}
