import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';

class DriverTripDetailsScreen extends StatelessWidget {
  final DriverTripDetailsArgs args;
  const DriverTripDetailsScreen({super.key, required this.args});

  bool get _isFuel => args.serviceType == 'fuel';
  bool get _isCompleted => true;

  // Mock data
  static const _pickupAddress = 'شارع التحرير، وسط البلد، القاهرة';
  static const _deliveryAddress = 'شارع الهرم، الجيزة';
  static const _customerName = 'أحمد محمد';
  static const _customerPhone = '0912345678';
  static const _amount = '150 ج.م';
  static const _paymentMethod = 'نقداً';
  static const _fuelTypeName = 'بنزين 95';
  static const _fuelQuantity = '40 لتر';
  static const _fuelPricePerLiter = '12.50 ج.م';
  static const _carTypeName = 'تويوتا كامري 2022';
  static const _carPlateNumber = 'أ ب م - 3541';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: AppStrings.driverTripDetails),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusBadge(),
                  SizedBox(height: Sizes.s16),
                  _buildLocationSection(),
                  SizedBox(height: Sizes.s16),
                  if (_isFuel) ...[
                    _buildFuelDetailsSection(),
                    SizedBox(height: Sizes.s16),
                  ] else ...[
                    _buildCarDetailsSection(),
                    SizedBox(height: Sizes.s16),
                  ],
                  _buildCustomerInfoSection(),
                  SizedBox(height: Sizes.s16),
                  _buildPaymentSummarySection(),
                  SizedBox(height: Sizes.s16),
                  _buildPhotoLogSection(),
                  SizedBox(height: Sizes.s32),
                ],
              ),
            ),
          ),
          if (!args.isRated) _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s8,
        ),
        decoration: BoxDecoration(
          color: _isCompleted
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.s24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isCompleted
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              size: 18.sp,
              color: _isCompleted ? AppColors.success : AppColors.error,
            ),
            SizedBox(width: Insets.s8),
            Text(
              _isCompleted ? AppStrings.completed : AppStrings.cancelled,
              style: getMediumStyle(
                color: _isCompleted ? AppColors.success : AppColors.error,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: Sizes.s8),
      child: Text(
        title,
        style: getBoldStyle(
          color: AppColors.black,
          fontSize: FontSize.s18,
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.location),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLocationRow(
                icon: Icons.circle,
                iconColor: AppColors.success,
                label: AppStrings.carLocation,
                address: _pickupAddress,
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 8.w),
                child: Column(
                  children: List.generate(
                    3,
                    (_) => Container(
                      width: 2.w,
                      height: 6.h,
                      margin: EdgeInsets.symmetric(vertical: 1.5.h),
                      color: AppColors.neutral600,
                    ),
                  ),
                ),
              ),
              _buildLocationRow(
                icon: Icons.location_on,
                iconColor: AppColors.error,
                label: AppStrings.deliveryDestinationLabel,
                address: _deliveryAddress,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: iconColor),
        SizedBox(width: Insets.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.s12,
                ),
              ),
              SizedBox(height: Sizes.s4),
              Text(
                address,
                style: getMediumStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFuelDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.fuelDetails),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDetailRow(AppStrings.fuelType, _fuelTypeName),
              Divider(height: Sizes.s24, color: AppColors.divider),
              _buildDetailRow(AppStrings.orderedQuantity, _fuelQuantity),
              Divider(height: Sizes.s24, color: AppColors.divider),
              _buildDetailRow(AppStrings.pricePerLiter, _fuelPricePerLiter),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.carDetails),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDetailRow(AppStrings.carType, _carTypeName),
              Divider(height: Sizes.s24, color: AppColors.divider),
              _buildDetailRow(AppStrings.plateNumber, _carPlateNumber),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getRegularStyle(
            color: AppColors.grey,
            fontSize: FontSize.s14,
          ),
        ),
        Text(
          value,
          style: getMediumStyle(
            color: AppColors.black,
            fontSize: FontSize.s14,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.customerInfo),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.neutral300,
                child: Icon(
                  Icons.person,
                  size: 28.sp,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(width: Insets.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _customerName,
                      style: getMediumStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    SizedBox(height: Sizes.s4),
                    Text(
                      _customerPhone,
                      style: getRegularStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone_outlined,
                  size: 20.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.paymentSummaryLabel),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDetailRow(AppStrings.totalAmount, _amount),
              Divider(height: Sizes.s24, color: AppColors.divider),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.cashPayment,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 18.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: Insets.s4),
                      Text(
                        _paymentMethod,
                        style: getMediumStyle(
                          color: AppColors.black,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoLogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.photoLog),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.pickupPhotos,
                style: getMediumStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s14,
                ),
              ),
              SizedBox(height: Sizes.s8),
              Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        end: index < 2 ? Insets.s8 : 0,
                      ),
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: AppColors.neutral300,
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 28.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Sizes.s16),
              Text(
                AppStrings.deliveryPhotos,
                style: getMediumStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s14,
                ),
              ),
              SizedBox(height: Sizes.s8),
              Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        end: index < 2 ? Insets.s8 : 0,
                      ),
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: AppColors.neutral300,
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 28.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s24),
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
      child: AppButton(
        text: AppStrings.rateTripButton,
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.driverRateCustomer,
            arguments: DriverRateArgs(orderId: args.orderId),
          );
        },
      ),
    );
  }
}
