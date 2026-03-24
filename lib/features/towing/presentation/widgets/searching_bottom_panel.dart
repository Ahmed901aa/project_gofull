import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class SearchingBottomPanel extends StatelessWidget {
  final int secondsLeft;
  final Animation<double> progressAnimation;

  const SearchingBottomPanel({
    super.key,
    required this.secondsLeft,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final mm = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (secondsLeft % 60).toString().padLeft(2, '0');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(
        children: [
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(children: [
              TextSpan(text: 'الوقت المتوقع للعثور على سائق: ', style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
              TextSpan(text: '$mm:$ss دقيقة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
            ]),
          ),
          SizedBox(height: Insets.s8),
          AnimatedBuilder(
            animation: progressAnimation,
            builder: (_, __) => Container(
              height: 6.h,
              decoration: BoxDecoration(color: const Color(0xFFD9DADB), borderRadius: BorderRadius.circular(AppRadius.s16)),
              child: FractionallySizedBox(
                widthFactor: progressAnimation.value,
                alignment: Alignment.centerRight,
                child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.s16))),
              ),
            ),
          ),
          SizedBox(height: Insets.s16),
          SizedBox(
            height: 48.h, width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close_rounded, size: 20.sp, color: AppColors.primary),
              label: Text('إلغاء الطلب', style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s16)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
