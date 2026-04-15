import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  final bool showBack;
  const SupportScreen({super.key, this.showBack = true});

  String _getPhone(BuildContext context) {
    try {
      return context.read<AppConfigBloc>().state.supportPhone;
    } catch (_) {
      return '0915909734';
    }
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWhatsApp(String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/218$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
            AppHeader(title: 'الدعم والمساعدة', showBack: showBack),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Hero section
                    _buildHeroSection(),
                    SizedBox(height: 24.h),

                    // Contact options
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تواصل معنا',
                            style: getBoldStyle(
                              color: const Color(0xFF0E0E0E),
                              fontSize: FontSize.s18,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Builder(builder: (ctx) {
                            final phone = _getPhone(ctx);
                            return Column(children: [
                              _ContactOptionCard(
                                icon: Icons.phone_rounded,
                                iconBgColor: AppColors.primary,
                                title: 'اتصال مباشر',
                                subtitle: phone,
                                onTap: () => _makeCall(phone),
                              ),
                              SizedBox(height: 10.h),
                              _ContactOptionCard(
                                icon: Icons.chat_rounded,
                                iconBgColor: const Color(0xFF25D366),
                                title: 'واتساب',
                                subtitle: 'محادثة فورية مع فريق الدعم',
                                onTap: () => _openWhatsApp(phone),
                              ),
                            ]);
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // FAQ section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الأسئلة الشائعة',
                            style: getBoldStyle(
                              color: const Color(0xFF0E0E0E),
                              fontSize: FontSize.s18,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          const _FaqItem(
                            question: 'كيف أطلب خدمة وقود؟',
                            answer:
                                'من الصفحة الرئيسية، اختر "تعبئة وقود" ثم حدد نوع الوقود والكمية وموقعك، وسيتم إرسال مزود خدمة إليك.',
                          ),
                          const _FaqItem(
                            question: 'كيف أطلب خدمة سحب (ساحبة)؟',
                            answer:
                                'من الصفحة الرئيسية، اختر "ساحبة" ثم حدد موقع الاستلام وموقع التسليم وأدخل بيانات السيارة.',
                          ),
                          const _FaqItem(
                            question: 'هل يمكنني إلغاء الطلب؟',
                            answer:
                                'نعم، يمكنك إلغاء الطلب قبل قبوله من قبل مزود الخدمة من خلال الضغط على زر الإلغاء.',
                          ),
                          const _FaqItem(
                            question: 'ما هي طرق الدفع المتاحة؟',
                            answer:
                                'حالياً يتم الدفع نقداً عند إتمام الخدمة.',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Builder(builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return Column(
        children: [
          SvgPicture.asset(
            SvgAssets.helpUser,
            width: screenWidth,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 12.h),
          Text(
            'كيف يمكننا مساعدتك؟',
            style: getBoldStyle(
              color: const Color(0xFF0E0E0E),
              fontSize: FontSize.s22,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'فريقنا جاهز لخدمتك',
            style: getRegularStyle(
              color: AppColors.neutral800,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      );
    });
  }

}

// ── Contact Option Card ──────────────────────────────────────

class _ContactOptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactOptionCard({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: const Color(0xFFEFF0F1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: iconBgColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22.sp, color: iconBgColor),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getSemiBoldStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: FontSize.s14,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: AppColors.neutral800,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.neutral800,
            ),
          ],
        ),
      ),
    );
  }
}

// ── FAQ Expandable Item ──────────────────────────────────────

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(
          color: _expanded
              ? AppColors.primary.withValues(alpha: 0.3)
              : const Color(0xFFEFF0F1),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(Insets.s12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: getMediumStyle(
                        color: const Color(0xFF0E0E0E),
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  Insets.s12, 0, Insets.s12, Insets.s12),
              child: Text(
                widget.answer,
                style: getRegularStyle(
                  color: AppColors.neutral800,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
