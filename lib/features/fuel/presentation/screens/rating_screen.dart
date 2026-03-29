import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(children: [
        _buildHeader(context),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('كيف كانت تجربتك؟',
                      style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
                  SizedBox(height: 4.h),
                  Text(
                    'ملاحظاتك تساعدنا في تحسين جودة خدماتنا وتطوير أداء السائقين.',
                    style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Insets.s16),
                  _buildStars(),
                ],
              ),
            ),
          ),
        ),
        _buildBottomButton(context),
      ]),
    );
  }

  Widget _buildStars() => Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final star = i + 1;
            return GestureDetector(
              onTap: () => setState(() => _rating = star),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  _rating >= star ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 40.sp,
                  color: _rating >= star ? const Color(0xFFFFB800) : const Color(0xFF141B34),
                ),
              ),
            );
          }),
        ),
      );

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: const Color(0xFF0E0E0E)),
                ),
                Text('تقييم الرحلة',
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );

  Widget _buildBottomButton(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCCCCCC).withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: SizedBox(
          height: 48.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
              elevation: 0,
            ),
            child: Text('إرسال التقييم', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
          ),
        ),
      );
}
