import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class TowingScreen extends StatefulWidget {
  const TowingScreen({super.key});

  @override
  State<TowingScreen> createState() => _TowingScreenState();
}

class _TowingScreenState extends State<TowingScreen> {
  String? _selectedCarType;
  final List<String> _carTypes = ['سيدان', 'SUV', 'بيك أب', 'شاحنة', 'هاتشباك'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Insets.s16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: _buildSafetyNotice(),
                    ),
                    SizedBox(height: Insets.s24),
                    // Trip route section
                    _buildSectionTitle('مسار الرحلة'),
                    SizedBox(height: Insets.s16),
                    _buildLocationCard(
                      topLabel: 'نقطة الانطلاق',
                      bottomLabel: 'موقع السيارة الحالي',
                    ),
                    SizedBox(height: Insets.s12),
                    _buildLocationCard(
                      topLabel: 'وجهة التوصيل',
                      bottomLabel: 'وجهة سحب السيارة',
                    ),
                    SizedBox(height: Insets.s24),
                    // Car details section
                    _buildSectionTitle('تفاصيل السيارة'),
                    SizedBox(height: Insets.s16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildFieldLabel('نوع السيارة'),
                          SizedBox(height: Insets.s8),
                          _buildDropdown(
                            hint: 'اختر نوع السيارة',
                            value: _selectedCarType,
                            items: _carTypes,
                            onChanged: (v) => setState(() => _selectedCarType = v),
                          ),
                          SizedBox(height: Insets.s12),
                          _buildFieldLabel('رقم اللوحة'),
                          SizedBox(height: Insets.s8),
                          _buildInputField(hint: 'أدخل رقم اللوحة'),
                          SizedBox(height: Insets.s12),
                          _buildFieldLabel('صورة السيارة'),
                          SizedBox(height: Insets.s8),
                          _buildPhotoSection(),
                        ],
                      ),
                    ),
                    SizedBox(height: Insets.s24),
                    // Notes section
                    _buildSectionTitle('ملاحظات إضافية'),
                    SizedBox(height: Insets.s8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: _buildInputField(hint: 'ملاحظات إضافية عن حالة السيارة'),
                    ),
                    SizedBox(height: Insets.s24),
                    // Payment summary
                    _buildSectionTitle('ملخص الدفع'),
                    SizedBox(height: Insets.s16),
                    _buildPaymentSummary(),
                    SizedBox(height: Insets.s16),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 22.sp,
                    color: const Color(0xFF0E0E0E),
                  ),
                ),
                Text(
                  'خدمة ونش',
                  style: getBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s20,
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
  }

  Widget _buildSafetyNotice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE1E3),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFE63946)),
      ),
      child: RichText(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'سلامتك أولاً...',
              style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            ),
            TextSpan(
              text: ' إذا كنت في موقع غير آمن، يرجى الانتقال لمكان أفضل أو الاتصال بالطوارئ فوراً.',
              style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildLocationCard({required String topLabel, required String bottomLabel}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F6),
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: const Color(0xFFD9DADB)),
        ),
        child: Row(
          children: [
            // Location icon — RIGHT (first in RTL)
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppRadius.s16),
              ),
              child: Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16.sp),
            ),
            SizedBox(width: Insets.s8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topLabel,
                  style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s12),
                ),
                SizedBox(height: 3.h),
                Text(
                  bottomLabel,
                  style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
                ),
              ],
            ),
            const Spacer(),
            // Arrow — LEFT (last in RTL), faces left in RTL
            Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: const Color(0xFF0E0E0E)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Align(
            alignment: Alignment.centerRight,
            child: Text(
              hint,
              style: getRegularStyle(color: const Color(0xFFAAAAAB), fontSize: FontSize.s14),
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.neutral900, size: 20.sp),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        item,
                        style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildInputField({required String hint}) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextField(
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getRegularStyle(color: const Color(0xFFAAAAAB), fontSize: FontSize.s14),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Row(
      children: [
        // Camera slot — RIGHT (first in RTL)
        Expanded(
          child: Container(
            height: 88.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F9),
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: const Color(0xFFEFF0F1)),
            ),
            child: Center(
              child: Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 32.sp),
            ),
          ),
        ),
        SizedBox(width: Insets.s16),
        // Photo preview slot — middle
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 88.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                  border: Border.all(color: const Color(0xFFEFF0F1)),
                ),
                child: Center(
                  child: Icon(Icons.directions_car_outlined, color: AppColors.neutral900, size: 32.sp),
                ),
              ),
              Positioned(
                top: -8.h,
                right: -8.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  child: Icon(Icons.edit_outlined, color: AppColors.white, size: 12.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: Insets.s16),
        // Empty placeholder slot — LEFT (last in RTL)
        Expanded(
          child: Container(
            height: 88.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F9),
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: const Color(0xFFEFF0F1)),
            ),
            child: Center(
              child: Icon(Icons.image_outlined, color: AppColors.neutral800, size: 32.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      children: [
        _buildPaymentRow('المجموع', '940.00 ج.م'),
        _buildServiceFeeRow(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          child: const Divider(height: 1, color: Color(0xFFEFF0F1)),
        ),
        SizedBox(height: Insets.s8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'الإجمالي',
                    style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s18),
                  ),
                  SizedBox(width: Insets.s8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(AppRadius.s16),
                    ),
                    child: Text(
                      'كاش',
                      style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s12),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '985.00 ج.م',
                style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              ),
            ],
          ),
        ),
        SizedBox(height: Insets.s8),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
      child: Row(
        children: [
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
          const Spacer(),
          Text(amount, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ],
      ),
    );
  }

  Widget _buildServiceFeeRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                'رسوم الخدمة',
                style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.info_outline_rounded, size: 16.sp, color: AppColors.primary),
            ],
          ),
          const Spacer(),
          Text(
            '15.00 ج.م',
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
          ),
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF54867C),
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
            elevation: 0,
          ),
          child: Text(
            'تأكيد',
            style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16),
          ),
        ),
      ),
    );
  }
}
