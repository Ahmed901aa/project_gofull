import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  static const _email = 'support@gofull.ly';

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

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {'subject': 'طلب دعم فني - تطبيق GoFull'},
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
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
                          SizedBox(height: 10.h),
                          _ContactOptionCard(
                            icon: Icons.email_rounded,
                            iconBgColor: AppColors.info,
                            title: 'البريد الإلكتروني',
                            subtitle: _email,
                            onTap: _sendEmail,
                          ),
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
                            question: 'كيف أطلب خدمة سحب (ونش)؟',
                            answer:
                                'من الصفحة الرئيسية، اختر "ونش" ثم حدد موقع الاستلام وموقع التسليم وأدخل بيانات السيارة.',
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
                    SizedBox(height: 24.h),

                    // Working hours
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: _buildWorkingHours(),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.scaffoldBg,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.headset_mic_rounded,
              size: 40.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'كيف يمكننا مساعدتك؟',
            style: getBoldStyle(
              color: const Color(0xFF0E0E0E),
              fontSize: FontSize.s22,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'فريقنا جاهز لخدمتك على مدار الساعة',
            style: getRegularStyle(
              color: AppColors.neutral800,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHours() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: 22.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ساعات العمل',
                  style: getSemiBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'متاح 24 ساعة - 7 أيام في الأسبوع',
                  style: getRegularStyle(
                    color: AppColors.neutral800,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'متاح الآن',
                  style: getMediumStyle(
                    color: AppColors.success,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
