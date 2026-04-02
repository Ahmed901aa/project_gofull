import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

// replace with API data later
const _sections = [
  {
    'title': '1. عام (General)',
    'body': 'باستخدامك لتطبيق "دايم". أنت توافق على الالتزام بكافة الشروط المذكورة هنا لضمان أفضل تجربة تسوق.\nيحق لنا تحديث هذه الشروط من وقت لآخر، وسيتم إخطارك بأي تغييرات جوهرية تطرأ عليها.',
  },
  {
    'title': '2. الطلبات والأسعار (Orders & Pricing)',
    'body': 'أسعار المنتجات هي نفس أسعار فتح الله جملة ماركت وقت الطلب، مع مراعاة وجود عروض حصرية داخل التطبيق.\nبالنسبة للمنتجات التي تعتمد على الوزن (كاللحوم والخضروات)، قد يختلف السعر النهائي بشكل طفيف بناءً على الوزن الفعلي وقت التجهيز، ويتم تسوية أي فرق في محفظتك تلقائياً.\nيحق للتطبيق إلغاء الطلب في حال عدم توفر المنتج أو وجود خطأ تقني في التسعير، مع التزامنا برد أي مبالغ مدفوعة لمحفظتك.',
  },
  {
    'title': '3. التوصيل (Delivery)',
    'body': 'نسعى لتوصيل طلبك في الوقت المحدد (من 45 لـ 90 دقيقة)، ولكن قد يتأثر الوقت بظروف خارجة عن إرادتنا كازدحام الطرق أو الظروف الجوية.\nيجب تواجد العميل أو من ينوب عنه في العنوان المحدد لاستلام الطلب، وفي حال تعذر الوصول إليك، قد يتم إلغاء الطلب مع فرض رسوم توصيل.',
  },
  {
    'title': '4. المحفظة والاسترداد (Wallet & Refunds)',
    'body': 'المبالغ الموجودة في المحفظة ناتجة عن (شحن رصيد، استرداد فرق وزن، أو تعويض عن منتج)، ويمكنك استخدامها في طلباتك القادمة.',
  },
];

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
                  children: _sections.map((s) => Padding(
                    padding: EdgeInsets.only(bottom: Insets.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s['title']!,
                          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                        ),
                        SizedBox(height: Insets.s8),
                        Text(
                          s['body']!,
                          style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  )).toList(),
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
                    child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'الشروط والأحكام',
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
}
