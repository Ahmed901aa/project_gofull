import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';

class DriverPrivacyPolicyScreen extends StatelessWidget {
  const DriverPrivacyPolicyScreen({super.key});

  static const _sections = [
    _PolicySection(
      icon: Icons.info_outline_rounded,
      title: 'مقدمة',
      body:
          'مرحباً بك في تطبيق GO FULL للسائقين. نحن نقدر خصوصيتك ونلتزم بحماية '
          'بياناتك الشخصية. توضح هذه السياسة كيفية جمع واستخدام وحماية معلوماتك '
          'عند استخدام خدماتنا كسائق أو مقدم خدمة.',
    ),
    _PolicySection(
      icon: Icons.folder_outlined,
      title: 'البيانات التي نجمعها',
      body:
          '• الاسم ورقم الهاتف وبيانات التسجيل\n'
          '• صور الهوية ورخصة القيادة\n'
          '• موقعك الجغرافي أثناء تقديم الخدمة\n'
          '• تفاصيل الطلبات والمعاملات المالية\n'
          '• بيانات المركبة ومعلومات التأمين\n'
          '• معلومات الجهاز لتحسين الأداء',
    ),
    _PolicySection(
      icon: Icons.settings_outlined,
      title: 'كيف نستخدم بياناتك',
      body:
          '• تشغيل خدمات إمداد الوقود وسحب المركبات\n'
          '• تحديد موقعك لتوجيه الطلبات القريبة إليك\n'
          '• احتساب الأرباح ومعالجة المدفوعات\n'
          '• تقييم جودة الخدمة وأدائك\n'
          '• التواصل معك بشأن الطلبات والتحديثات\n'
          '• ضمان أمان وسلامة المعاملات',
    ),
    _PolicySection(
      icon: Icons.share_outlined,
      title: 'مشاركة البيانات',
      body:
          '• نشارك اسمك ورقم هاتفك ومعلومات المركبة مع العميل أثناء الطلب\n'
          '• نشارك موقعك الحالي مع العميل لتتبع وصولك\n'
          '• لا نبيع بياناتك الشخصية لأي أطراف ثالثة\n'
          '• قد نشارك بيانات مجهولة الهوية لأغراض تحليلية',
    ),
    _PolicySection(
      icon: Icons.shield_outlined,
      title: 'حماية البيانات',
      body:
          'نستخدم تقنيات تشفير متقدمة لحماية بياناتك. نحتفظ ببياناتك '
          'فقط طالما كان حسابك نشطاً أو حسب ما يقتضيه القانون. يتم تخزين '
          'جميع المعلومات على خوادم آمنة مع مراقبة مستمرة.',
    ),
    _PolicySection(
      icon: Icons.location_on_outlined,
      title: 'بيانات الموقع',
      body:
          'نستخدم موقعك الجغرافي فقط أثناء تفعيل حالة "متاح" أو أثناء تنفيذ '
          'الطلبات. يمكنك إيقاف مشاركة الموقع في أي وقت عبر تغيير حالتك إلى '
          '"غير متاح". لا يتم تتبع موقعك خارج أوقات العمل.',
    ),
    _PolicySection(
      icon: Icons.gavel_outlined,
      title: 'حقوقك',
      body:
          '• طلب الوصول إلى بياناتك الشخصية\n'
          '• طلب تصحيح أو تحديث بياناتك\n'
          '• طلب حذف حسابك وبياناتك\n'
          '• سحب موافقتك في أي وقت\n'
          '• تقديم شكوى للجهات المختصة',
    ),
    _PolicySection(
      icon: Icons.headset_mic_outlined,
      title: 'التواصل معنا',
      body:
          'إذا كان لديك أي استفسارات حول سياسة الخصوصية أو كيفية التعامل مع '
          'بياناتك، يرجى التواصل معنا عبر قسم الدعم الفني في التطبيق أو '
          'مراسلتنا على البريد الإلكتروني: support@gofull.ly',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            const AppHeader(title: 'سياسة الخصوصية'),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App info card
                    Container(
                      padding: EdgeInsets.all(Insets.s16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A6B54), Color(0xFF004B3B)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.s16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Image.asset(
                                ImageAssets.logo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: Insets.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GO FULL — سياسة الخصوصية',
                                  style: getBoldStyle(
                                    color: AppColors.white,
                                    fontSize: FontSize.s16,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'آخر تحديث: أبريل 2026',
                                  style: getRegularStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Policy sections
                    for (int i = 0; i < _sections.length; i++) ...[
                      _SectionCard(
                        section: _sections[i],
                        index: i,
                      ),
                      SizedBox(height: 12.h),
                    ],

                    SizedBox(height: 8.h),

                    // Footer
                    Center(
                      child: Text(
                        '© 2026 GO FULL. جميع الحقوق محفوظة.',
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _PolicySection section;
  final int index;

  const _SectionCard({
    required this.section,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  section.icon,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: Insets.s10),
              Expanded(
                child: Text(
                  section.title,
                  style: getBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            section.body,
            style: getRegularStyle(
              color: AppColors.darkGrey,
              fontSize: FontSize.s14,
            ).copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final IconData icon;
  final String title;
  final String body;
  const _PolicySection({
    required this.icon,
    required this.title,
    required this.body,
  });
}
