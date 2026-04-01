// replace with API data later
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/service_location_card.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/trip_payment_card.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/towing/presentation/widgets/arrived_car_photos.dart';
import 'package:project_gofull/features/towing/presentation/widgets/driver_details_card.dart';
import 'package:project_gofull/features/towing/presentation/widgets/photo_log_section.dart';

class TowingTripDetailsScreen extends StatelessWidget {
  final TripDetailsArgs? args;
  const TowingTripDetailsScreen({super.key, this.args});

  bool get _showRatingButton {
    if (args == null) return true; // default: show when opened outside orders flow
    return args!.status == OrderStatus.completed && !args!.isRated;
  }

  bool get _showAlreadyRatedText {
    if (args == null) return false;
    return args!.status == OrderStatus.completed && args!.isRated;
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
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Sizes.s8),
                  _section(
                    'مسار الرحلة',
                    Column(
                      children: [
                        // replace with API data later
                        const ServiceLocationCard(
                          topLabel: 'نقطة الانطلاق',
                          bottomLabel: 'المنصورة، مدينة مبارك، شارع مكة',
                        ),
                        SizedBox(height: Sizes.s8),
                        const ServiceLocationCard(
                          topLabel: 'وجهة التوصيل',
                          bottomLabel: 'الرياض، حي النزهة، شارع الأمير',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Insets.s16),
                  _section(
                    'تفاصيل السيارة',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // replace with API data later
                        Row(
                          children: [
                            _DetailChip(label: 'رقم اللوحة: أ ب م - 3541'),
                            SizedBox(width: Insets.s8),
                            _DetailChip(label: 'نوع السيارة: نيسان صني'),
                          ],
                        ),
                        SizedBox(height: Sizes.s8),
                        const ArrivedCarPhotos(),
                      ],
                    ),
                  ),
                  SizedBox(height: Insets.s16),
                  _section(
                    'تفاصيل السائق',
                    // replace with API data later
                    const DriverDetailsCard(
                      name: 'محمد أحمد',
                      rating: '4.9',
                      reviewCount: '541',
                      plateNumber: 'أ ب م - 3541',
                      vehicleLabel: 'نوع الونش',
                      vehicleValue: 'ونش هيدروليك',
                    ),
                  ),
                  SizedBox(height: Insets.s16),
                  _section('ملخص الدفع', const TripPaymentCard()),
                  SizedBox(height: Insets.s16),
                  const PhotoLogSection(),
                  SizedBox(height: Sizes.s16),
                ],
              ),
            ),
          ),
          if (_showRatingButton) _buildRatingButton(context),
          if (_showAlreadyRatedText) _buildAlreadyRatedText(),
        ],
      ),
    );
  }

  Widget _section(String title, Widget content) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: Insets.s8),
          content,
        ],
      );

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
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20.sp,
                      color: const Color(0xFF0E0E0E),
                    ),
                  ),
                  Text(
                    'تفاصيل الرحلة',
                    style: getBoldStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: FontSize.s20,
                    ),
                  ),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 24.sp,
                    color: const Color(0xFF0E0E0E),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildRatingButton(BuildContext context) => Container(
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
            onPressed: () => Navigator.pushNamed(context, Routes.rating),
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
      );

  Widget _buildAlreadyRatedText() => Container(
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
        child: Center(
          child: Text(
            'تم التقييم',
            style: getMediumStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
          ),
        ),
      );
}

class _DetailChip extends StatelessWidget {
  final String label;
  const _DetailChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Text(
        label,
        style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s12),
      ),
    );
  }
}
