import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

const _safetyItems = [
  ('تأكد من سلامة السيارة:', 'يرجى معاينة السيارة جيداً والتأكد من عدم وجود أي أضرار ناتجة عن عملية السحب قبل إنهاء الطلب.'),
  ('تأكد من الموقع:', 'تأكد من وضع السيارة في مكان آمن ومن قانونية الوقوف في هذا الموقع لتجنب المخالفات أو الحوادث.'),
  ('استلام المقتنيات:', 'تأكد من استلام مفاتيح السيارة وكافة أغراضك الشخصية التي قد تكون تركتها مع السائق أو داخل المقصورة.'),
  ('السلامة في موقع الإنزال:', 'إذا كان الموقع مزدحماً، يرجى الحذر عند التحرك حول الونش أثناء إنزال السيارة.'),
  ('المعاملة المالية:', 'لا تدفع أي مبالغ إضافية غير الموضحة في التطبيق؛ وفي حال طلب السائق ذلك، يرجى التواصل مع الدعم فوراً.'),
];

class ArrivedSafetyCard extends StatefulWidget {
  const ArrivedSafetyCard({super.key});

  @override
  State<ArrivedSafetyCard> createState() => _ArrivedSafetyCardState();
}

class _ArrivedSafetyCardState extends State<ArrivedSafetyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'إرشادات الأمان',
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_expanded)
                Text(
                  'يرجى التأكد من وجودك في وجهة التوصيل أو وجود شخص لاستلام السيارة عند وصول السائق.',
                  style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14),
                  textAlign: TextAlign.right,
                ),
              if (_expanded)
                for (final (title, body) in _safetyItems) ...[
                  Text(title, style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14), textAlign: TextAlign.right),
                  SizedBox(height: 2.h),
                  Text('"$body"', style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14), textAlign: TextAlign.right),
                  SizedBox(height: Insets.s12),
                ],
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'أخفاء العرض' : 'عرض الكل',
                  style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s14),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
