import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class SafetySection extends StatelessWidget {
  static const _items = [
    'تأمين السيارة: يرجى ركن السيارة في مكان آمن ومنبسط.',
    'إطفاء المحرك: تأكد من إطفاء المحرك تماماً قبل بدء التعبئة.',
    'تأكيد النوع: جاري تحضير (بنزين 95) حسب طلبك.',
    'إجراءات السلامة: يرجى الامتناع عن التدخين تماماً في منطقة التعبئة.',
  ];

  const SafetySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('إرشادات الأمان', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
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
            children: _items.map((t) => _BulletItem(text: t, last: t == _items.last)).toList(),
          ),
        ),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final bool last;
  const _BulletItem({required this.text, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 6.w),
            child: Container(
              width: 5.w, height: 5.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Text(text, style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
