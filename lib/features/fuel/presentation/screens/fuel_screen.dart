import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  String? _selectedFuelType;
  String? _selectedQuantity;

  final List<String> _fuelTypes = ['بنزين 91', 'بنزين 95', 'ديزل'];
  final List<String> _quantities = ['20 لتر', '30 لتر', '40 لتر', '50 لتر'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Insets.s16),
                    // Safety notice
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: _buildSafetyNotice(),
                    ),
                    SizedBox(height: Insets.s24),
                    // Location section
                    _buildSectionTitle('الموقع'),
                    SizedBox(height: Insets.s16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: _buildLocationCard(),
                    ),
                    SizedBox(height: Insets.s24),
                    // Fuel details section
                    _buildSectionTitle('تفاصيل الوقود'),
                    SizedBox(height: Insets.s16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildFieldLabel('نوع الوقود'),
                          SizedBox(height: Insets.s8),
                          _buildDropdown(
                            hint: 'اختر نوع الوقود',
                            value: _selectedFuelType,
                            items: _fuelTypes,
                            onChanged: (v) =>
                                setState(() => _selectedFuelType = v),
                          ),
                          SizedBox(height: Insets.s12),
                          _buildFieldLabel('الكمية المطلوبة'),
                          SizedBox(height: 2.h),
                          Text(
                            'سيتم إضافة رسوم الخدمة والتوصيل إلى سعر الوقود.',
                            style: getRegularStyle(
                              color: AppColors.neutral800,
                              fontSize: FontSize.s14,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: Insets.s8),
                          _buildDropdown(
                            hint: 'اختر الكمية المطلوبة',
                            value: _selectedQuantity,
                            items: _quantities,
                            onChanged: (v) =>
                                setState(() => _selectedQuantity = v),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Insets.s24),
                    // Notes section
                    _buildSectionTitle('ملاحظات إضافية'),
                    SizedBox(height: Insets.s8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: _buildNotesField(),
                    ),
                    SizedBox(height: Insets.s24),
                    // Payment summary section
                    _buildSectionTitle('ملخص الدفع'),
                    SizedBox(height: Insets.s16),
                    _buildPaymentSummary(),
                    SizedBox(height: Insets.s16),
                  ],
                ),
              ),
            ),
            // Pinned bottom button
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
            padding: EdgeInsets.fromLTRB(
              Insets.s16,
              Insets.s12,
              Insets.s16,
              Insets.s12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button — RIGHT side (first in RTL)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 22.sp,
                    color: const Color(0xFF0E0E0E),
                  ),
                ),
                // Title
                Text(
                  'إمداد وقود',
                  style: getBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s20,
                  ),
                ),
                // Empty space (LEFT in RTL — balances the layout)
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
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s12,
      ),
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
              style: getBoldStyle(
                color: const Color(0xFF0E0E0E),
                fontSize: FontSize.s14,
              ),
            ),
            TextSpan(
              text:
                  ' إذا كنت في موقع غير آمن، يرجى الانتقال لمكان أفضل أو الاتصال بالطوارئ فوراً.',
              style: getRegularStyle(
                color: const Color(0xFF0E0E0E),
                fontSize: FontSize.s14,
              ),
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
          style: getBoldStyle(
            color: const Color(0xFF0E0E0E),
            fontSize: FontSize.s18,
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: getMediumStyle(
        color: const Color(0xFF0E0E0E),
        fontSize: FontSize.s16,
      ),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F6),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFD9DADB)),
      ),
      child: Row(
        children: [
          // Location icon — RIGHT (first in RTL row)
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 16.sp,
            ),
          ),
          SizedBox(width: Insets.s8),
          // Text block
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الموقع الحالي',
                style: getRegularStyle(
                  color: AppColors.neutral800,
                  fontSize: FontSize.s12,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'موقع السيارة الحالي',
                style: getRegularStyle(
                  color: AppColors.neutral900,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
          const Spacer(),
          // → arrow on LEFT (last in RTL row)
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.sp,
            color: const Color(0xFF0E0E0E),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      {required String hint,
      required String? value,
      required List<String> items,
      required ValueChanged<String?> onChanged}) {
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
              style: getRegularStyle(
                color: const Color(0xFFAAAAAB),
                fontSize: FontSize.s14,
              ),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.neutral900,
            size: 20.sp,
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        item,
                        style: getMediumStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildNotesField() {
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
          style: getRegularStyle(
            color: const Color(0xFF0E0E0E),
            fontSize: FontSize.s14,
          ),
          decoration: InputDecoration(
            hintText: 'ملاحظات إضافية عن حالة السيارة',
            hintStyle: getRegularStyle(
              color: const Color(0xFFAAAAAB),
              fontSize: FontSize.s14,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      children: [
        _buildPaymentRow('المجموع', '940.00 ج.م'),
        _buildPaymentRow('التوصيل', '40.00 ج.م'),
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.s8,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius:
                          BorderRadius.circular(AppRadius.s16),
                    ),
                    child: Text(
                      'كاش',
                      style: getRegularStyle(
                        color: AppColors.primary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                  SizedBox(width: Insets.s8),
                  Text(
                    'الإجمالي',
                    style: getRegularStyle(
                      color: AppColors.neutral900,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '985.00 ج.م',
                style: getBoldStyle(
                  color: const Color(0xFF0E0E0E),
                  fontSize: FontSize.s18,
                ),
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
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s8,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: getRegularStyle(
              color: AppColors.neutral900,
              fontSize: FontSize.s16,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: getBoldStyle(
              color: const Color(0xFF0E0E0E),
              fontSize: FontSize.s16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceFeeRow() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s8,
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16.sp,
                color: AppColors.neutral900,
              ),
              SizedBox(width: 4.w),
              Text(
                'رسوم الخدمة',
                style: getRegularStyle(
                  color: AppColors.neutral900,
                  fontSize: FontSize.s16,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '15.00 ج.م',
            style: getBoldStyle(
              color: const Color(0xFF0E0E0E),
              fontSize: FontSize.s16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.s16),
        ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.s16),
            ),
            elevation: 0,
          ),
          child: Text(
            'تأكيد',
            style: getBoldStyle(
              color: AppColors.white,
              fontSize: FontSize.s16,
            ),
          ),
        ),
      ),
    );
  }
}
