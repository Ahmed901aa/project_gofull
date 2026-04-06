import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    _PolicySection(
      title: 'مقدمة',
      body:
          'مرحباً بك في تطبيق GO FULL. نحن نقدر خصوصيتك ونلتزم بحماية بياناتك الشخصية. '
          'توضح هذه السياسة كيفية جمع واستخدام وحماية معلوماتك عند استخدام خدماتنا.',
    ),
    _PolicySection(
      title: 'البيانات التي نجمعها',
      body:
          '• الاسم ورقم الهاتف عند التسجيل\n'
          '• موقعك الجغرافي لتحديد نقطة الخدمة\n'
          '• تفاصيل الطلبات والمعاملات\n'
          '• معلومات الجهاز لتحسين الأداء',
    ),
    _PolicySection(
      title: 'كيف نستخدم بياناتك',
      body:
          '• تقديم خدمات إمداد الوقود وسحب المركبات\n'
          '• تحسين جودة الخدمة وتجربة المستخدم\n'
          '• التواصل معك بشأن طلباتك\n'
          '• ضمان أمان وسلامة المعاملات',
    ),
    _PolicySection(
      title: 'حماية البيانات',
      body:
          'نستخدم تقنيات تشفير متقدمة لحماية بياناتك. لا نشارك معلوماتك الشخصية '
          'مع أطراف ثالثة إلا بموافقتك أو عند الضرورة القانونية.',
    ),
    _PolicySection(
      title: 'حقوقك',
      body:
          '• طلب الوصول إلى بياناتك الشخصية\n'
          '• طلب تصحيح أو حذف بياناتك\n'
          '• سحب موافقتك في أي وقت\n'
          '• تقديم شكوى للجهات المختصة',
    ),
    _PolicySection(
      title: 'التواصل معنا',
      body:
          'إذا كان لديك أي استفسارات حول سياسة الخصوصية، يرجى التواصل معنا '
          'عبر قسم الدعم الفني في التطبيق.',
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
                    for (final section in _sections) ...[
                      Text(
                        section.title,
                        style: getBoldStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s18),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        section.body,
                        style: getRegularStyle(
                            color: AppColors.darkGrey,
                            fontSize: FontSize.s14),
                      ),
                      SizedBox(height: 20.h),
                    ],
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

class _PolicySection {
  final String title;
  final String body;
  const _PolicySection({required this.title, required this.body});
}
