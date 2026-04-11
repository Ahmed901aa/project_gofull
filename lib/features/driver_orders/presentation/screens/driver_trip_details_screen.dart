import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/utils/route_args.dart';

class DriverTripDetailsScreen extends StatefulWidget {
  final DriverTripDetailsArgs args;

  const DriverTripDetailsScreen({super.key, required this.args});

  @override
  State<DriverTripDetailsScreen> createState() =>
      _DriverTripDetailsScreenState();
}

class _DriverTripDetailsScreenState extends State<DriverTripDetailsScreen> {
  Map<String, dynamic>? _order;
  bool _isLoading = true;

  bool get _isTow => widget.args.serviceType == 'tow' || widget.args.serviceType == 'towing';

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final response = await sl<ApiClient>()
          .dio
          .get(ApiConstants.providerRequestDetails(int.parse(widget.args.orderId)));
      if (mounted) {
        setState(() {
          _order = response.data['data'] as Map<String, dynamic>?;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Helpers to extract data safely ──
  String get _driverAddress => (_order?['driver_address'] as String?) ?? 'غير محدد';
  String get _destinationAddress => (_order?['destination_address'] as String?) ?? 'غير محدد';
  String get _fuelQuantity => (_order?['fuel_quantity'] as String?) ?? '-';
  String get _fuelType {
    final t = _order?['fuel_type'] as String?;
    if (t == 'petrol' || t == 'gasoline') return 'بنزين';
    if (t == 'diesel') return 'ديزل';
    return t ?? '-';
  }
  String get _pricePerLiter => (_order?['price_per_liter'] as String?) ?? '-';
  String get _plateNumber => (_order?['plate_number'] as String?) ?? '-';
  String get _subtotal => (_order?['subtotal'] as String?) ?? '0.00';
  String get _serviceFee => (_order?['service_fee'] as String?) ?? '0.00';
  String get _total => (_order?['total'] as String?) ?? '0.00';
  String get _paymentMethod {
    final m = _order?['payment_method'] as String?;
    return m == 'cash' ? 'كاش' : (m ?? 'كاش');
  }
  String get _customerName {
    final driver = _order?['driver'] as Map<String, dynamic>?;
    return (driver?['name'] as String?) ?? 'العميل';
  }
  String get _customerPhone {
    final driver = _order?['driver'] as Map<String, dynamic>?;
    return (driver?['phone'] as String?) ?? '';
  }

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
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary))
                  : _order == null
                      ? Center(
                          child: Text('فشل تحميل تفاصيل الرحلة',
                              style: getRegularStyle(
                                  color: AppColors.grey,
                                  fontSize: FontSize.s14)))
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.all(Insets.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:
                                _isTow ? _towSections() : _fuelSections(),
                          ),
                        ),
            ),
            if (!widget.args.isRated && !_isLoading && _order != null)
              _buildBottomButton(context),
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
                Navigator.pushNamed(context, Routes.driverRateCustomer,
                    arguments: DriverRateArgs(orderId: widget.args.orderId)),
          ),
        ),
      );

  // ── Towing Sections ─────────────────────────────────────

  List<Widget> _towSections() => [
        _sectionTitle('مسار الرحلة'),
        SizedBox(height: Insets.s8),
        _TripRouteTimeline(
          pickupAddress: _driverAddress,
          deliveryAddress: _destinationAddress,
        ),
        SizedBox(height: Insets.s20),
        _sectionTitle('تفاصيل السيارة'),
        SizedBox(height: Insets.s8),
        _CarDetailsSection(plateNumber: _plateNumber),
        SizedBox(height: Insets.s20),
        _sectionTitle('معلومات العميل'),
        SizedBox(height: Insets.s8),
        _CustomerInfoSection(name: _customerName, phone: _customerPhone),
        SizedBox(height: Insets.s20),
        _sectionTitle('ملخص الدفع'),
        SizedBox(height: Insets.s8),
        _PaymentSummarySection(
            total: _total, paymentMethod: _paymentMethod),
        SizedBox(height: Insets.s16),
      ];

  // ── Fuel Sections ───────────────────────────────────────

  List<Widget> _fuelSections() => [
        _sectionTitle('الموقع'),
        SizedBox(height: Insets.s8),
        _LocationSection(address: _driverAddress),
        SizedBox(height: Insets.s20),
        _sectionTitle('تفاصيل الوقود'),
        SizedBox(height: Insets.s8),
        _FuelDetailsSection(
          quantity: '$_fuelQuantity لتر',
          fuelType: _fuelType,
          pricePerLiter: '$_pricePerLiter د.ل',
        ),
        SizedBox(height: Insets.s20),
        _sectionTitle('معلومات العميل'),
        SizedBox(height: Insets.s8),
        _CustomerInfoSection(name: _customerName, phone: _customerPhone),
        SizedBox(height: Insets.s20),
        _sectionTitle('ملخص الدفع'),
        SizedBox(height: Insets.s8),
        _PaymentSummarySection(
            total: _total, paymentMethod: _paymentMethod),
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
  final String pickupAddress;
  final String deliveryAddress;
  const _TripRouteTimeline({required this.pickupAddress, required this.deliveryAddress});

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
            Column(
              children: [
                Container(
                  width: 12.w, height: 12.w,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
                Expanded(
                  child: CustomPaint(
                    painter: _DottedLinePainter(color: AppColors.primary),
                    size: Size(2.w, 0),
                  ),
                ),
                Container(
                  width: 12.w, height: 12.w,
                  decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                ),
              ],
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('نقطة الانطلاق',
                      style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12)),
                  SizedBox(height: 2.h),
                  Text(pickupAddress,
                      style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
                  SizedBox(height: Insets.s20),
                  Text('وجهة التوصيل',
                      style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12)),
                  SizedBox(height: 2.h),
                  Text(deliveryAddress,
                      style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
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
  final String address;
  const _LocationSection({required this.address});

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
                Text('موقع السيارة',
                    style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12)),
                SizedBox(height: 2.h),
                Text(address,
                    style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
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
  final String quantity;
  final String fuelType;
  final String pricePerLiter;
  const _FuelDetailsSection({
    required this.quantity,
    required this.fuelType,
    required this.pricePerLiter,
  });

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
          _detailRow('الكمية المطلوبة', quantity),
          SizedBox(height: Insets.s12),
          _detailRow('نوع الوقود', fuelType),
          SizedBox(height: Insets.s12),
          _detailRow('سعر لتر اليوم', pricePerLiter),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) => Row(
        children: [
          Text(label,
              style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
          const Spacer(),
          Text(value,
              style: getSemiBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        ],
      );
}

// ── Car Details Section ──────────────────────────────────

class _CarDetailsSection extends StatelessWidget {
  final String plateNumber;
  const _CarDetailsSection({required this.plateNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _badgeCard('رقم اللوحة', plateNumber)),
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
            Text(label,
                style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12)),
            SizedBox(height: 4.h),
            Text(value,
                style: getSemiBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
          ],
        ),
      );
}

// ── Customer Info Section ────────────────────────────────

class _CustomerInfoSection extends StatelessWidget {
  final String name;
  final String phone;
  const _CustomerInfoSection({required this.name, required this.phone});

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
          Container(
            width: 48.w, height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary200, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.person_rounded, size: 24.sp, color: AppColors.primary),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: getSemiBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
                SizedBox(height: 2.h),
                Text(phone,
                    style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12),
                    textDirection: TextDirection.ltr),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payment Summary ──────────────────────────────────────

class _PaymentSummarySection extends StatelessWidget {
  final String total;
  final String paymentMethod;
  const _PaymentSummarySection({required this.total, required this.paymentMethod});

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
          Text('الإجمالي',
              style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
          SizedBox(width: Insets.s8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
            ),
            child: Text(paymentMethod,
                style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s12)),
          ),
          const Spacer(),
          Text('$total د.ل',
              style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        ],
      ),
    );
  }
}
