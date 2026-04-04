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

class OrderPopupCard extends StatelessWidget {
  final String serviceType;
  final String distance;
  final String customerName;
  final String pickupAddress;
  final String deliveryAddress;
  final String price;
  final String paymentMethod;
  final String orderId;
  final VoidCallback? onDismiss;

  const OrderPopupCard({
    super.key,
    this.serviceType = 'ونش',
    this.distance = '3.5',
    this.customerName = 'أحمد محمد',
    this.pickupAddress = 'المنصورة، شارع الجمهورية، بجوار مسجد النور',
    this.deliveryAddress = 'المنصورة، مدينة مبارك، شارع مكة',
    this.price = '150 ج.م',
    this.paymentMethod = 'كاش',
    this.orderId = 'ORD-001',
    this.onDismiss,
  });

  bool get _isTow => serviceType == 'ونش';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.s24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16.r,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.neutral600,
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
            ),
          ),
          SizedBox(height: Sizes.s16),
          _buildHeaderRow(),
          SizedBox(height: Sizes.s16),
          _buildCustomerRow(),
          SizedBox(height: Sizes.s16),
          _buildAddressSection(),
          SizedBox(height: Sizes.s16),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: Sizes.s16),
          _buildPriceRow(),
          SizedBox(height: Sizes.s24),
          _buildActions(context),
          SizedBox(height: Sizes.s8),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        _buildServiceBadge(),
        const Spacer(),
        Icon(
          Icons.near_me_outlined,
          size: 16.w,
          color: AppColors.grey,
        ),
        SizedBox(width: Insets.s4),
        Text(
          '${AppStrings.distanceAway} $distance ${AppStrings.km}',
          style: getRegularStyle(
            color: AppColors.grey,
            fontSize: FontSize.s12,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s12,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: _isTow ? AppColors.primary50 : AppColors.goldLight,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isTow ? Icons.fire_truck : Icons.local_gas_station,
            size: 16.w,
            color: _isTow ? AppColors.primary : AppColors.gold,
          ),
          SizedBox(width: Insets.s4),
          Text(
            _isTow ? AppStrings.towService : AppStrings.fuelService,
            style: getSemiBoldStyle(
              color: _isTow ? AppColors.primary : AppColors.gold,
              fontSize: FontSize.s12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: AppColors.neutral300,
          child: Icon(
            Icons.person,
            size: 20.w,
            color: AppColors.grey,
          ),
        ),
        SizedBox(width: Insets.s12),
        Text(
          customerName,
          style: getSemiBoldStyle(
            color: AppColors.darkGrey,
            fontSize: FontSize.s14,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAddressRow(
          icon: Icons.radio_button_checked,
          iconColor: AppColors.success,
          label: pickupAddress,
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 11.w),
          child: Container(
            width: 2.w,
            height: Sizes.s20,
            color: AppColors.neutral600,
          ),
        ),
        _buildAddressRow(
          icon: Icons.location_on,
          iconColor: AppColors.error,
          label: deliveryAddress,
        ),
      ],
    );
  }

  Widget _buildAddressRow({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22.w, color: iconColor),
        SizedBox(width: Insets.s12),
        Expanded(
          child: Text(
            label,
            style: getMediumStyle(
              color: AppColors.darkGrey,
              fontSize: FontSize.s14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              price,
              style: getBoldStyle(
                color: AppColors.primary,
                fontSize: FontSize.s18,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.s12,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(AppRadius.s8),
          ),
          child: Text(
            paymentMethod,
            style: getMediumStyle(
              color: AppColors.darkGrey,
              fontSize: FontSize.s12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: Sizes.s48,
            child: OutlinedButton(
              onPressed: () => onDismiss?.call(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                foregroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                ),
              ),
              child: Text(
                AppStrings.rejectOrder,
                style: getBoldStyle(
                  color: AppColors.error,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: AppButton(
            text: AppStrings.orderDetails,
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.driverOrderDetails,
                arguments: DriverOrderDetailsArgs(
                  orderId: orderId,
                  serviceType: serviceType,
                  customerName: customerName,
                  customerPhone: '+20 1234 567 890',
                  pickupAddress: pickupAddress,
                  deliveryAddress: deliveryAddress,
                  carType: 'تويوتا كامري 2022',
                  plateNumber: 'أ ب م - 3541',
                  distance: distance,
                  amount: 150.0,
                  paymentMethod: paymentMethod,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
