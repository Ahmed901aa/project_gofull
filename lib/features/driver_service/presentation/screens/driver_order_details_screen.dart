import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';

class DriverOrderDetailsScreen extends StatelessWidget {
  final DriverOrderDetailsArgs args;
  const DriverOrderDetailsScreen({super.key, required this.args});

  bool get _isTowing => args.serviceType == 'tow';
  bool get _isFuel => args.serviceType == 'fuel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: 'تفاصيل الطلب'),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCustomerInfoCard(context),
                  SizedBox(height: Insets.s16),
                  _buildServiceBadge(),
                  if (_isTowing) ...[
                    SizedBox(height: Insets.s16),
                    _buildCarPhotosSection(),
                  ],
                  if (_isFuel) ...[
                    SizedBox(height: Insets.s16),
                    _buildFuelDetailsSection(),
                  ],
                  SizedBox(height: Insets.s16),
                  _buildTripRouteCard(),
                  if (args.customerNotes != null &&
                      args.customerNotes!.isNotEmpty) ...[
                    SizedBox(height: Insets.s16),
                    _buildCustomerNotesCard(),
                  ],
                  SizedBox(height: Insets.s16),
                  _buildPaymentSummaryCard(),
                  SizedBox(height: Sizes.s48),
                ],
              ),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات العميل',
            style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
          ),
          SizedBox(height: Insets.s12),
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 26.sp, color: AppColors.primary),
              ),
              SizedBox(width: Insets.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      args.customerName,
                      style: getSemiBoldStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    SizedBox(height: Insets.s4),
                    GestureDetector(
                      onTap: () => _callCustomer(),
                      child: Row(
                        children: [
                          Icon(Icons.phone_outlined, size: 16.sp, color: AppColors.primary),
                          SizedBox(width: Insets.s4),
                          Text(
                            args.customerPhone,
                            style: getMediumStyle(
                              color: AppColors.primary,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _callCustomer(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone, size: 20.sp, color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s12),
          _infoRow(Icons.directions_car_outlined, 'نوع السيارة', args.carType),
          SizedBox(height: Insets.s8),
          _infoRow(Icons.confirmation_number_outlined, 'رقم اللوحة', args.plateNumber),
        ],
      ),
    );
  }

  Widget _buildServiceBadge() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: Insets.s4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.s24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isTowing ? Icons.local_shipping_outlined : Icons.local_gas_station_outlined,
              size: 18.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: Insets.s4),
            Text(
              _isTowing ? 'خدمة ونش' : 'خدمة وقود',
              style: getMediumStyle(color: AppColors.primary, fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarPhotosSection() {
    final photos = args.carPhotos;
    final hasPhotos = photos != null && photos.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صور السيارة',
          style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hasPhotos ? photos.length : 4,
            separatorBuilder: (_, __) => SizedBox(width: Insets.s8),
            itemBuilder: (_, index) {
              return Container(
                width: 120.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: AppColors.neutral400,
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  border: Border.all(
                    color: AppColors.grey.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 32.sp,
                    color: AppColors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFuelDetailsSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل الوقود',
            style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
          ),
          SizedBox(height: Insets.s12),
          if (args.fuelType != null)
            _infoRow(Icons.local_gas_station_outlined, 'نوع الوقود', args.fuelType!),
          if (args.fuelQuantity != null) ...[
            SizedBox(height: Insets.s8),
            _infoRow(Icons.water_drop_outlined, 'الكمية', args.fuelQuantity!),
          ],
          if (args.pricePerLiter != null) ...[
            SizedBox(height: Insets.s8),
            _infoRow(Icons.attach_money_rounded, 'سعر اللتر', args.pricePerLiter!),
          ],
        ],
      ),
    );
  }

  Widget _buildTripRouteCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مسار الرحلة',
            style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
          ),
          SizedBox(height: Insets.s12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(Icons.location_on, size: 20.sp, color: AppColors.success),
                  Container(
                    width: 2,
                    height: 24.h,
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  Icon(Icons.location_on, size: 20.sp, color: AppColors.error),
                ],
              ),
              SizedBox(width: Insets.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      args.pickupAddress,
                      style: getRegularStyle(
                        color: AppColors.darkGrey,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    SizedBox(height: Insets.s20),
                    Text(
                      args.deliveryAddress,
                      style: getRegularStyle(
                        color: AppColors.darkGrey,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: Insets.s4),
            decoration: BoxDecoration(
              color: AppColors.neutral400,
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Text(
              'على بعد ${args.distance} كم',
              style: getMediumStyle(color: AppColors.grey, fontSize: FontSize.s12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerNotesCard() {
    return _card(
      color: AppColors.neutral400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note_alt_outlined, size: 20.sp, color: AppColors.primary),
              SizedBox(width: Insets.s8),
              Text(
                'ملاحظات العميل',
                style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
              ),
            ],
          ),
          SizedBox(height: Insets.s8),
          Text(
            args.customerNotes!,
            style: getRegularStyle(color: AppColors.darkGrey, fontSize: FontSize.s14),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الدفع',
            style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
          ),
          SizedBox(height: Insets.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المبلغ الإجمالي',
                style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
              ),
              Text(
                '${args.amount.toStringAsFixed(0)} ج.م',
                style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
              ),
            ],
          ),
          SizedBox(height: Insets.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طريقة الدفع',
                style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
              ),
              Row(
                children: [
                  Icon(Icons.money_rounded, size: 18.sp, color: AppColors.primary),
                  SizedBox(width: Insets.s4),
                  Text(
                    args.paymentMethod,
                    style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'رفض الطلب',
              isOutlined: true,
              textColor: AppColors.error,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: AppButton(
              text: 'قبول الطلب',
              onPressed: () => _showConfirmDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        title: Text(
          'تأكيد قبول الطلب',
          style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s18),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في قبول هذا الطلب؟ سيتم إشعار العميل فوراً.',
          style: getRegularStyle(color: AppColors.darkGrey, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: 120.w,
            child: AppButton(
              text: 'إلغاء',
              isOutlined: true,
              onPressed: () => Navigator.pop(ctx),
            ),
          ),
          SizedBox(width: Insets.s8),
          SizedBox(
            width: 120.w,
            child: AppButton(
              text: 'تأكيد القبول',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(
                  context,
                  Routes.driverNavigate,
                  arguments: DriverNavigateArgs(
                    orderId: args.orderId,
                    address: args.pickupAddress,
                    navigationType: 'to_customer',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callCustomer() async {
    final uri = Uri.parse('tel:${args.customerPhone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.grey),
        SizedBox(width: Insets.s8),
        Text(
          '$label: ',
          style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
        ),
        Expanded(
          child: Text(
            value,
            style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child, Color? color}) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
