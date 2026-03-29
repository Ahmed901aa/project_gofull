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
  final TextEditingController _notesController = TextEditingController();
  static const int _maxNoteLength = 80;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s32),
              child: Column(
                children: [
                  _buildRatingSection(),
                  if (_rating > 0) ...[
                    SizedBox(height: Insets.s24),
                    _buildNotesSection(),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'كيف كانت تجربتك؟',
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
        ),
        SizedBox(height: 2.h),
        Text(
          'ملاحظاتك تساعدنا في تحسين جودة خدماتنا وتطوير أداء السائقين.',
          style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s16),
        _buildStars(),
      ],
    );
  }

  Widget _buildStars() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          final star = i + 1;
          return GestureDetector(
            onTap: () => setState(() => _rating = star),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Icon(
                _rating >= star ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 40.sp,
                color: const Color(0xFFFFB800),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضف ملاحظاتك',
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: TextField(
            controller: _notesController,
            maxLength: _maxNoteLength,
            maxLines: 4,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            decoration: InputDecoration(
              hintText: 'اكتب هنا أي تفاصيل إضافية تود مشاركتها...',
              hintStyle: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
              contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.s8),
          child: Text(
            '${_notesController.text.length}/$_maxNoteLength',
            style: getMediumStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 20.sp, color: const Color(0xFF0E0E0E)),
                ),
                Text(
                  'تقييم الرحلة',
                  style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                ),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
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
          onPressed: _rating == 0
              ? null
              : () => Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (route) => false),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
            elevation: 0,
          ),
          child: Text(
            'إرسال التقييم',
            style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16),
          ),
        ),
      ),
    );
  }
}
