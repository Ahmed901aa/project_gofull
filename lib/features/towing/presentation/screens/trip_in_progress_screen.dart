import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import '../widgets/driver_details_card.dart';
import '../widgets/trip_mock_trigger_button.dart';
import '../widgets/trip_photo_placeholder.dart';
import '../widgets/trip_route_card.dart';
import '../widgets/trip_payment_section.dart';
import '../widgets/trip_safety_section.dart';

// replace with API data later
const _mockDriver = {
  'name': 'محمود عبدالعليم',
  'rating': '4.9',
  'reviewCount': '541',
  'plateNumber': 'أ ب م - 3541',
  'vehicleType': 'ونش هيدروليك',
};

const _mockRoute = {
  'origin': 'المنصورة، مدينة مبارك، شارع مكة..., 30, 11',
  'destination': 'المنصورة، مدينة مبارك، شارع مكة..., 30, 11',
  'distance': '14 كم',
};

const _mockPayment = {
  'subtotal': '940.00 ج.م',
  'serviceFee': '15.00 ج.م',
  'total': '985.00 ج.م',
};

String _calcDistance(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = (lat2 - lat1) * pi / 180;
  final dLng = (lng2 - lng1) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLng / 2) * sin(dLng / 2);
  final km = r * 2 * atan2(sqrt(a), sqrt(1 - a));
  return '${km.toStringAsFixed(1)} كم';
}

class TripInProgressScreen extends StatelessWidget {
  final TripInProgressArgs? args;
  const TripInProgressScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(children: [
        _buildHeader(context),
        MockTriggerButton(
          label: 'محاكاة: وصل السائق للوجهة',
          onTap: () => Navigator.pushReplacementNamed(context, Routes.driverArrived, arguments: args),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(Insets.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Insets.s16),
                const Center(child: DottedCircleContainer(imagePath: 'assets/images/crane (1).gif')),
                SizedBox(height: Insets.s16),
                Text(
                  'سيارتك في طريقها إلى وجهة التوصيل.',
                  style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  'يتم الآن تحميل وتأمين السيارة على الونش لبدء الرحلة إلى وجهتك.',
                  style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Insets.s24),
                const TripSafetySection(),
                SizedBox(height: Insets.s16),
                _buildTripRoute(),
                SizedBox(height: Insets.s16),
                _buildCarPhotos(),
                SizedBox(height: Insets.s16),
                _buildDriverDetails(),
                SizedBox(height: Insets.s16),
                TripPaymentSection(
                  subtotal: _mockPayment['subtotal']!,
                  serviceFee: _mockPayment['serviceFee']!,
                  total: _mockPayment['total']!,
                ),
                SizedBox(height: Insets.s16),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24.sp),
                Text('الرحلة قيد التنفيذ', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );

  Widget _buildTripRoute() {
    final origin = args?.originAddress ?? _mockRoute['origin']!;
    final destination = args?.destinationAddress ?? _mockRoute['destination']!;
    String distance;
    if (args?.originLat != null && args?.originLng != null &&
        args?.destinationLat != null && args?.destinationLng != null) {
      distance = _calcDistance(args!.originLat!, args!.originLng!, args!.destinationLat!, args!.destinationLng!);
    } else {
      distance = _mockRoute['distance']!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('مسار الرحلة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
        SizedBox(height: Insets.s8),
        TripRouteCard(title: 'نقطة الانطلاق', address: origin),
        SizedBox(height: Insets.s8),
        TripRouteCard(title: 'وجهة التوصيل', address: destination, distanceLabel: 'المسافة المتبقية:', distanceValue: distance),
      ],
    );
  }

  Widget _buildCarPhotos() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('صور السيارة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
          SizedBox(height: Insets.s8),
          Row(children: List.generate(3, (i) => Expanded(
            child: Padding(padding: EdgeInsets.only(right: i < 2 ? Insets.s8 : 0), child: const TripPhotoPlaceholder()),
          ))),
        ],
      );

  Widget _buildDriverDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('تفاصيل السائق', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
          SizedBox(height: Insets.s8),
          DriverDetailsCard(
            name: _mockDriver['name']!,
            rating: _mockDriver['rating']!,
            reviewCount: _mockDriver['reviewCount']!,
            plateNumber: _mockDriver['plateNumber']!,
            vehicleLabel: 'نوع الونش',
            vehicleValue: _mockDriver['vehicleType']!,
            showActionIcons: true,
          ),
        ],
      );
}
