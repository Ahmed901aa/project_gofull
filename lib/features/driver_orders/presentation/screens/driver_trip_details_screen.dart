import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/driver_orders/presentation/screens/driver_orders_screen.dart';

class DriverTripDetailsScreen extends StatelessWidget {
  final DriverTripDetailsArgs args;

  const DriverTripDetailsScreen({super.key, required this.args});

  bool get _isTow => args.serviceType == 'tow';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                  children: _isTow ? _towSections() : _fuelSections(),
                ),
              ),
            ),
            if (!args.isRated) _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'تفاصيل الرحلة',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: AppColors.grey),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  // ── Bottom Button ───────────────────────────────────────

  Widget _buildBottomButton(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
          Insets.s16,
          Insets.s12,
          Insets.s16,
          Insets.s24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          top: false,
          child: AppButton(
            text: 'تقييم الرحلة',
            onPressed: () =>
                Navigator.pushNamed(context, Routes.driverRateCustomer),
          ),
        ),
      );

  // ── Towing Sections ─────────────────────────────────────

  List<Widget> _towSections() => [
        _sectionTitle('مسار الرحلة'),
        SizedBox(height: Insets.s8),
        _TripRouteTimeline(),
        SizedBox(height: Insets.s20),
        _sectionTitle('تفاصيل السيارة'),
        SizedBox(height: Insets.s8),
        _CarDetailsSection(),
        SizedBox(height: Insets.s20),
        _sectionTitle('معلومات العميل'),
        SizedBox(height: Insets.s8),
        _CustomerInfoSection(),
        SizedBox(height: Insets.s20),
        _sectionTitle('ملخص الدفع'),
        SizedBox(height: Insets.s8),
        _PaymentSummarySection(),
        SizedBox(height: Insets.s20),
        _PhotoLogExpandable(
          sections: [
            _PhotoGroup(title: 'صور الاستلام', count: 4),
            _PhotoGroup(title: 'صور التسليم', count: 4),
          ],
        ),
        SizedBox(height: Insets.s16),
      ];

  // ── Fuel Sections ───────────────────────────────────────

  List<Widget> _fuelSections() => [
        _sectionTitle('الموقع'),
        SizedBox(height: Insets.s8),
        _LocationSection(),
        SizedBox(height: Insets.s20),
        _sectionTitle('تفاصيل الوقود'),
        SizedBox(height: Insets.s8),
        _FuelDetailsSection(),
        SizedBox(height: Insets.s20),
        _sectionTitle('تفاصيل السيارة'),
        SizedBox(height: Insets.s8),
        _CarDetailsSection(),
        SizedBox(height: Insets.s20),
        _sectionTitle('معلومات العميل'),
        SizedBox(height: Insets.s8),
        _CustomerInfoSection(),
        SizedBox(height: Insets.s20),
        _sectionTitle('ملخص الدفع'),
        SizedBox(height: Insets.s8),
        _PaymentSummarySection(),
        SizedBox(height: Insets.s20),
        _PhotoLogExpandable(
          sections: [
            _PhotoGroup(title: 'سجل الصور', count: 4),
          ],
        ),
        SizedBox(height: Insets.s16),
      ];

  Widget _sectionTitle(String title) => Text(
        title,
        style: getBoldStyle(
            color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
      );
}

// ── Trip Route Timeline ──────────────────────────────────

class _TripRouteTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline dots + line
            Column(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: CustomPaint(
                    painter: _DottedLinePainter(color: AppColors.primary),
                    size: Size(2.w, 0),
                  ),
                ),
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(width: Insets.s12),
            // Addresses
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نقطة الانطلاق',
                    style: getRegularStyle(
                        color: AppColors.grey, fontSize: FontSize.s12),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'المنصورة، مدينة مبارك، شارع مكة',
                    style: getMediumStyle(
                        color: const Color(0xFF0E0E0E),
                        fontSize: FontSize.s14),
                  ),
                  SizedBox(height: Insets.s20),
                  Text(
                    'وجهة التوصيل',
                    style: getRegularStyle(
                        color: AppColors.grey, fontSize: FontSize.s12),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'الرياض، حي النزهة، شارع الأمير',
                    style: getMediumStyle(
                        color: const Color(0xFF0E0E0E),
                        fontSize: FontSize.s14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashGap = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Location Section (Fuel) ──────────────────────────────

class _LocationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 20.sp, color: AppColors.primary),
          SizedBox(width: Insets.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'موقع السيارة',
                  style: getRegularStyle(
                      color: AppColors.grey, fontSize: FontSize.s12),
                ),
                SizedBox(height: 2.h),
                Text(
                  'المنصورة، مدينة مبارك، شارع مكة',
                  style: getMediumStyle(
                      color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fuel Details Section ─────────────────────────────────

class _FuelDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        children: [
          _detailRow('الكمية المطلوبة', '20 لتر'),
          SizedBox(height: Insets.s12),
          _detailRow('نوع الوقود', 'بنزين 95'),
          SizedBox(height: Insets.s12),
          _detailRow('سعر لتر اليوم', '12.50 ج.م'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) => Row(
        children: [
          Text(
            label,
            style: getRegularStyle(
                color: AppColors.neutral900, fontSize: FontSize.s14),
          ),
          const Spacer(),
          Text(
            value,
            style: getSemiBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
          ),
        ],
      );
}

// ── Car Details Section ──────────────────────────────────

class _CarDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _badgeCard('نوع السيارة', 'نيسان صني')),
            SizedBox(width: Insets.s8),
            Expanded(child: _badgeCard('رقم اللوحة', 'أ ب م - 3541')),
          ],
        ),
        SizedBox(height: Insets.s12),
        // Car images placeholder
        Container(
          height: 160.h,
          decoration: BoxDecoration(
            color: AppColors.neutral400,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Row(
            children: List.generate(
              2,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Insets.s8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      border: Border.all(color: AppColors.neutral500),
                    ),
                    child: Icon(Icons.directions_car_rounded,
                        size: 40.sp, color: AppColors.neutral600),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _badgeCard(String label, String value) => Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.neutral400,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: getRegularStyle(
                  color: AppColors.grey, fontSize: FontSize.s12),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: getSemiBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            ),
          ],
        ),
      );
}

// ── Customer Info Section ────────────────────────────────

class _CustomerInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary200, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.person_rounded,
                size: 24.sp, color: AppColors.primary),
          ),
          SizedBox(width: Insets.s12),
          // Name & phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحمد محمد',
                  style: getSemiBoldStyle(
                      color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                ),
                SizedBox(height: 2.h),
                Text(
                  '+965 5534 5368',
                  style: getRegularStyle(
                      color: AppColors.grey, fontSize: FontSize.s12),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
          // Call button
          GestureDetector(
            onTap: () {
              // replace with url_launcher call
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.phone_rounded,
                  size: 20.sp, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payment Summary ──────────────────────────────────────

class _PaymentSummarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(
        children: [
          Text(
            'الإجمالي',
            style: getRegularStyle(
                color: AppColors.neutral900, fontSize: FontSize.s16),
          ),
          SizedBox(width: Insets.s8),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
            ),
            child: Text('كاش',
                style: getRegularStyle(
                    color: AppColors.primary, fontSize: FontSize.s12)),
          ),
          const Spacer(),
          Text(
            '985.00 ج.م',
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          ),
        ],
      ),
    );
  }
}

// ── Photo Log Expandable ─────────────────────────────────

class _PhotoGroup {
  final String title;
  final int count;
  const _PhotoGroup({required this.title, required this.count});
}

class _PhotoLogExpandable extends StatefulWidget {
  final List<_PhotoGroup> sections;
  const _PhotoLogExpandable({required this.sections});

  @override
  State<_PhotoLogExpandable> createState() => _PhotoLogExpandableState();
}

class _PhotoLogExpandableState extends State<_PhotoLogExpandable> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Insets.s16, vertical: Insets.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Text(
                    'سجل الصور',
                    style: getBoldStyle(
                        color: const Color(0xFF0E0E0E),
                        fontSize: FontSize.s16),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(color: AppColors.neutral500, height: 1, thickness: 1),
            Padding(
              padding: EdgeInsets.all(Insets.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.sections.map((group) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        group.title,
                        style: getMediumStyle(
                            color: AppColors.darkGrey, fontSize: FontSize.s14),
                      ),
                      SizedBox(height: Insets.s8),
                      Wrap(
                        spacing: Insets.s8,
                        runSpacing: Insets.s8,
                        children: List.generate(
                          group.count,
                          (_) => Container(
                            width:
                                (MediaQuery.of(context).size.width - 80.w) / 3,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: AppColors.neutral200,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s12),
                              border: Border.all(color: AppColors.neutral500),
                            ),
                            child: Icon(Icons.image_outlined,
                                size: 28.sp, color: AppColors.neutral600),
                          ),
                        ),
                      ),
                      SizedBox(height: Insets.s12),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
