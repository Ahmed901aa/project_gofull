import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';

// replace with API data later
const _mockData = {
  'quantity': '20 لتر',
  'fuelType': 'بنزين 95',
  'pricePerLiter': '16.00 ج.م',
  'subtotal': '940.00 ج.م',
  'serviceFee': '15.00 ج.م',
  'total': '985.00 ج.م',
};

const _safetyItems = [
  'إغلاق الخزان: تأكد من إغلاق غطاء وقود السيارة جيداً.',
  'المعاينة النهائية: تأكد من عدم وجود أي انسكابات وقود حول السيارة.',
  'الدفع: يرجى سداد المبلغ الإجمالي للسائق (كاش) أو عبر التطبيق.',
];

class FuelCompleteScreen extends StatefulWidget {
  const FuelCompleteScreen({super.key});

  @override
  State<FuelCompleteScreen> createState() => _FuelCompleteScreenState();
}

class _FuelCompleteScreenState extends State<FuelCompleteScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                children: [
                  SizedBox(height: Insets.s16),
                  _buildGradientCircle(),
                  SizedBox(height: Insets.s16),
                  _buildSuccessTexts(),
                  SizedBox(height: Insets.s24),
                  _buildExpandableSafety(),
                  SizedBox(height: Insets.s16),
                  _buildServiceDetails(),
                  SizedBox(height: Insets.s16),
                  _buildPaymentSection(),
                  SizedBox(height: Insets.s16),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
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
                    child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Text(
                    'اكتملت عملية التعبئة',
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

  // ── Gradient circle ───────────────────────────────────────────────────────

  Widget _buildGradientCircle() => Center(
        child: Container(
          width: 104.w,
          height: 104.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primary200],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Image.asset('assets/images/shield.gif', fit: BoxFit.contain),
          ),
        ),
      );

  // ── Success texts ─────────────────────────────────────────────────────────

  Widget _buildSuccessTexts() => Column(
        children: [
          Text(
            'تم تزويد سيارتك بالوقود بنجاح',
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            'تم إنزال السيارة في وجهة التوصيل المحددة. يرجى التأكد من سلامة السيارة قبل إتمام الدفع.',
            style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
            textAlign: TextAlign.center,
          ),
        ],
      );

  // ── Expandable safety section ─────────────────────────────────────────────

  Widget _buildExpandableSafety() => Column(
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
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _expanded ? _buildFullList() : _buildCollapsedItem(),
                ),
                SizedBox(height: Insets.s8),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? 'أخفاء العرض' : 'عرض الكل',
                    style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s14),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildCollapsedItem() => _BulletItem(text: _safetyItems.first, last: true);

  Widget _buildFullList() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _safetyItems
            .map((t) => _BulletItem(text: t, last: t == _safetyItems.last))
            .toList(),
      );

  // ── Service details ───────────────────────────────────────────────────────

  Widget _buildServiceDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'تفاصيل الخدمة',
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: Insets.s8),
          _detailRow('الكمية الفعلية', _mockData['quantity']!),
          _detailRow('نوع الوقود', _mockData['fuelType']!),
          _detailRow('سعر لتر اليوم', _mockData['pricePerLiter']!),
        ],
      );

  Widget _detailRow(String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.s8),
        child: Row(
          children: [
            Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            const Spacer(),
            Text(value, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          ],
        ),
      );

  // ── Payment section ───────────────────────────────────────────────────────

  Widget _buildPaymentSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ملخص الدفع',
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: Insets.s8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutral400,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral500),
            ),
            child: Column(
              children: [
                SizedBox(height: Insets.s8),
                _payRow('المجموع', _mockData['subtotal']!),
                _serviceFeeRow(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: const Divider(height: 1, color: AppColors.neutral600),
                ),
                SizedBox(height: Insets.s8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Row(
                    children: [
                      Row(children: [
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
                      ]),
                      const Spacer(),
                      Text(
                        _mockData['total']!,
                        style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Insets.s8),
              ],
            ),
          ),
        ],
      );

  Widget _payRow(String label, String amount) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(
          children: [
            Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            const Spacer(),
            Text(amount, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          ],
        ),
      );

  Widget _serviceFeeRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(
          children: [
            Row(children: [
              Text('رسوم الخدمة', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
              const SizedBox(width: 4),
              Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
            ]),
            const Spacer(),
            Text(
              _mockData['serviceFee']!,
              style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
          ],
        ),
      );

  // ── Bottom button ─────────────────────────────────────────────────────────

  Widget _buildBottomButton(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: SizedBox(
          height: 48.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.rating),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.s16),
              ),
              elevation: 0,
            ),
            child: Text(
              'تقييم الخدمة',
              style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16),
            ),
          ),
        ),
      );
}

// ── Shared bullet item ────────────────────────────────────────────────────────

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
              width: 5.w,
              height: 5.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
