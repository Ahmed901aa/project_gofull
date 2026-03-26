import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../widgets/driver_details_card.dart';
import '../widgets/gif_circle.dart';
import '../widgets/info_pill.dart';

// replace with API data later
const _mockDriver = {
  'name': 'محمود عبدالعليم',
  'rating': '4.9',
  'reviewCount': '541',
  'plateNumber': 'أ ب م - 3541',
  'vehicleType': 'ونش هيدروليك',
};

// fallback mock data
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
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(Insets.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Insets.s16),

                // ── Gradient circle with crane gif ───────────────────
                Center(child: GifCircle(imagePath: 'assets/images/crane (1).gif')),
                SizedBox(height: Insets.s16),

                // ── Status texts ─────────────────────────────────────
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

                // ── Safety instructions ──────────────────────────────
                _buildSafetySection(),
                SizedBox(height: Insets.s16),

                // ── Trip route ───────────────────────────────────────
                _buildTripRoute(),
                SizedBox(height: Insets.s16),

                // ── Car photos ───────────────────────────────────────
                _buildCarPhotos(),
                SizedBox(height: Insets.s16),

                // ── Driver details ───────────────────────────────────
                _buildDriverDetails(),
                SizedBox(height: Insets.s16),

                // ── Payment summary ──────────────────────────────────
                _buildPaymentSection(),
                SizedBox(height: Insets.s16),
              ],
            ),
          ),
        ),
      ]),
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
                  'الرحلة قيد التنفيذ',
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
            child: Text(
              'يرجى التأكد من وجودك في وجهة التوصيل أو وجود شخص لاستلام السيارة عند وصول السائق.',
              style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );

  // ── Trip route ──────────────────────────────────────────────────────────────

  Widget _buildTripRoute() {
    final origin = args?.originAddress ?? _mockRoute['origin']!; // fallback mock data
    final destination = args?.destinationAddress ?? _mockRoute['destination']!; // fallback mock data

    String distance;
    if (args?.originLat != null && args?.originLng != null &&
        args?.destinationLat != null && args?.destinationLng != null) {
      distance = _calcDistance(args!.originLat!, args!.originLng!, args!.destinationLat!, args!.destinationLng!);
    } else {
      distance = _mockRoute['distance']!; // fallback mock data
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'مسار الرحلة',
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: Insets.s8),
        _RouteCard(
          title: 'نقطة الانطلاق',
          address: origin,
        ),
        SizedBox(height: Insets.s8),
        _RouteCard(
          title: 'وجهة التوصيل',
          address: destination,
          distanceLabel: 'المسافة المتبقية:',
          distanceValue: distance,
        ),
      ],
    );
  }

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
            children: List.generate(3, (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i < 2 ? Insets.s8 : 0),
                child: _PhotoPlaceholder(),
              ),
            )),
          ),
        ],
      );

  // ── Driver details ──────────────────────────────────────────────────────────

  Widget _buildDriverDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'تفاصيل السائق',
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            textAlign: TextAlign.right,
          ),
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
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
          const Spacer(),
          Text(amount, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ]),
      );

  Widget _serviceFeeRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
        child: Row(children: [
          Row(children: [
            Text('رسوم الخدمة', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            const SizedBox(width: 4),
            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          ]),
          const Spacer(),
          Text(_mockPayment['serviceFee']!, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ]),
      );

  Widget _totalRow() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        child: Row(children: [
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
          const Spacer(),
          Text(_mockPayment['total']!, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        ]),
      );
}

// ── Route card ──────────────────────────────────────────────────────────────

class _RouteCard extends StatelessWidget {
  final String title;
  final String address;
  final String? distanceLabel;
  final String? distanceValue;

  const _RouteCard({
    required this.title,
    required this.address,
    this.distanceLabel,
    this.distanceValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neutral600,
              ),
              child: Icon(Icons.location_on_outlined, size: 32.sp, color: const Color(0xFF0E0E0E)),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
                  SizedBox(height: 2.h),
                  Text(address, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
                  if (distanceLabel != null && distanceValue != null) ...[
                    SizedBox(height: 2.h),
                    RichText(
                      textDirection: TextDirection.rtl,
                      text: TextSpan(children: [
                        TextSpan(
                          text: '$distanceLabel ',
                          style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                        ),
                        TextSpan(
                          text: distanceValue,
                          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                        ),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Photo placeholder ───────────────────────────────────────────────────────

class _PhotoPlaceholder extends StatelessWidget {
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
