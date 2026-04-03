import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_complete_payment_section.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_complete_safety_section.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';

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

class FuelCompleteScreen extends StatelessWidget {
  const FuelCompleteScreen({super.key});

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
                  const Center(child: DottedCircleContainer(imagePath: 'assets/images/shield.gif')),
                  SizedBox(height: Insets.s16),
                  _buildSuccessTexts(),
                  SizedBox(height: Insets.s24),
                  const FuelCompleteSafetySection(items: _safetyItems),
                  SizedBox(height: Insets.s16),
                  _buildServiceDetails(),
                  SizedBox(height: Insets.s16),
                  const FuelCompletePaymentSection(data: _mockData),
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
                  GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E))),
                  Text('اكتملت عملية التعبئة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                  Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildSuccessTexts() => Column(
        children: [
          Text('تم تزويد سيارتك بالوقود بنجاح', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
          SizedBox(height: 6.h),
          Text('تم إنزال السيارة في وجهة التوصيل المحددة. يرجى التأكد من سلامة السيارة قبل إتمام الدفع.',
              style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
        ],
      );

  Widget _buildServiceDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('تفاصيل الخدمة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
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
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.tripDetails,
                arguments: const TripDetailsArgs(orderId: 'fuel_active', status: OrderStatus.completed, isRated: false)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0,
            ),
            child: Text('تقييم الخدمة', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
          ),
        ),
      );
}
