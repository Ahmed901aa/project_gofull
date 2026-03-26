import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../widgets/gif_circle.dart';

// replace with API data later
const _mockPayment = {
  'subtotal': '940.00 ج.م',
  'serviceFee': '15.00 ج.م',
  'total': '985.00 ج.م',
};

class DriverArrivedScreen extends StatelessWidget {
  final TripInProgressArgs? args;
  const DriverArrivedScreen({super.key, this.args});

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

                  // ── Shield circle ────────────────────────────────────
                  Center(child: GifCircle(imagePath: 'assets/images/shield.gif')),
                  SizedBox(height: Insets.s16),

                  // ── Status texts ─────────────────────────────────────
                  Text(
                    'تمت المهمة بنجاح!',
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'تم إنزال السيارة في وجهة التوصيل المحددة. يرجى التأكد من سلامة السيارة قبل إتمام الدفع.',
                    style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Insets.s24),

                  // ── Safety instructions ──────────────────────────────
                  _buildSafetySection(),
                  SizedBox(height: Insets.s16),

                  // ── Car photos ───────────────────────────────────────
                  _buildCarPhotos(),
                  SizedBox(height: Insets.s16),

                  // ── Payment summary ──────────────────────────────────
                  _buildPaymentSection(),
                  SizedBox(height: Insets.s16),
                ],
              ),
            ),
          ),

          // ── Bottom action ────────────────────────────────────────────
          _buildBottomAction(context),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                Text(
                  'وصل السائق للوجهة',
                  style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                ),
                SizedBox(width: 24.sp),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );

  // ── Safety section ──────────────────────────────────────────────────────────

  Widget _buildSafetySection() => Column(
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
                Text(
                  'يرجى التأكد من وجودك في وجهة التوصيل أو وجود شخص لاستلام السيارة عند وصول السائق.',
                  style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 4.h),
                Text(
                  'عرض الكل',
                  style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s14),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      );

  // ── Car photos ──────────────────────────────────────────────────────────────

  Widget _buildCarPhotos() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'صور السيارة',
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: Insets.s8),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: i < 2 ? Insets.s8 : 0),
                  child: const _PhotoPlaceholder(),
                ),
              ),
            ),
          ),
        ],
      );

  // ── Payment section ─────────────────────────────────────────────────────────

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
            child: Column(children: [
              SizedBox(height: Insets.s8),
              _payRow('المجموع', _mockPayment['subtotal']!),
              _serviceFeeRow(),
              const Divider(height: 1, color: AppColors.neutral500),
              SizedBox(height: Insets.s8),
              _totalRow(),
              SizedBox(height: Insets.s8),
            ]),
          ),
        ],
      );

  Widget _payRow(String label, String amount) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Text(amount, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          const Spacer(),
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
        ]),
      );

  Widget _serviceFeeRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Text(_mockPayment['serviceFee']!, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          const Spacer(),
          Row(children: [
            Text('رسوم الخدمة', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            const SizedBox(width: 4),
            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          ]),
        ]),
      );

  Widget _totalRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        child: Row(children: [
          Text(_mockPayment['total']!, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
          const Spacer(),
          Row(children: [
            Text('الإجمالي', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s18)),
            SizedBox(width: Insets.s8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppRadius.s16),
              ),
              child: Text('كاش', style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s12)),
            ),
          ]),
        ]),
      );

  // ── Bottom action ───────────────────────────────────────────────────────────

  Widget _buildBottomAction(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: const [
            BoxShadow(color: Color(0x0ACCCCCC), blurRadius: 4, offset: Offset(0, -4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
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
                    'تقييم الرحلة',
                    style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      );
}

// ── Photo placeholder ────────────────────────────────────────────────────────

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Icon(Icons.image_outlined, size: 28.sp, color: AppColors.neutral600),
    );
  }
}
