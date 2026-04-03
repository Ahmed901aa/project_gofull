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
import 'package:project_gofull/features/towing/presentation/widgets/detail_chip.dart';
import 'package:project_gofull/features/towing/presentation/widgets/driver_details_card.dart';
import 'package:project_gofull/features/towing/presentation/widgets/photo_log_section.dart';
import 'package:project_gofull/features/towing/presentation/widgets/trip_rating_bottom_bar.dart';

class TowingTripDetailsScreen extends StatelessWidget {
  final TripDetailsArgs? args;
  const TowingTripDetailsScreen({super.key, this.args});

  bool get _showRatingButton =>
      args != null && args!.status == OrderStatus.completed && !args!.isRated;

  bool get _showAlreadyRatedText =>
      args != null && args!.status == OrderStatus.completed && args!.isRated;

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
                  _section('مسار الرحلة', Column(children: [
                    const ServiceLocationCard(topLabel: 'نقطة الانطلاق', bottomLabel: 'المنصورة، مدينة مبارك، شارع مكة'),
                    SizedBox(height: Sizes.s8),
                    const ServiceLocationCard(topLabel: 'وجهة التوصيل', bottomLabel: 'الرياض، حي النزهة، شارع الأمير'),
                  ])),
                  SizedBox(height: Insets.s16),
                  _section('تفاصيل السيارة', Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [const DetailChip(label: 'نوع السيارة: نيسان صني'), SizedBox(width: Insets.s8), const DetailChip(label: 'رقم اللوحة: أ ب م - 3541')]),
                    SizedBox(height: Sizes.s8),
                    const ArrivedCarPhotos(),
                  ])),
                  SizedBox(height: Insets.s16),
                  _section('تفاصيل السائق', const DriverDetailsCard(name: 'محمد أحمد', rating: '4.9', reviewCount: '541', plateNumber: 'أ ب م - 3541', vehicleLabel: 'نوع الونش', vehicleValue: 'ونش هيدروليك')),
                  SizedBox(height: Insets.s16),
                  _section('ملخص الدفع', const TripPaymentCard()),
                  SizedBox(height: Insets.s16),
                  const PhotoLogSection(),
                  SizedBox(height: Sizes.s16),
                ],
              ),
            ),
          ),
          if (_showRatingButton)
            TripRatingBottomBar(label: 'تقييم الرحلة', onPressed: () => Navigator.pushNamed(context, Routes.rating, arguments: args != null ? RatingArgs(orderId: args!.orderId) : null)),
          if (_showAlreadyRatedText) const AlreadyRatedBar(),
        ],
      ),
    );
  }

  Widget _section(String title, Widget content) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
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
                  GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: const Color(0xFF0E0E0E))),
                  Text('تفاصيل الرحلة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                  Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );
}
