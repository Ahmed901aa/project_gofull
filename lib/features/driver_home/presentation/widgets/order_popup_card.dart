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
  final String pickupAddress;
  final String deliveryAddress;
  final String estimatedPrice;
  final String orderId;

  const OrderPopupCard({
    super.key,
    this.serviceType = 'ونش',
    this.distance = '3.5',
    this.pickupAddress = 'المنصورة، شارع الجمهورية، بجوار مسجد النور',
    this.deliveryAddress = 'المنصورة، مدينة مبارك، شارع مكة',
    this.estimatedPrice = '150 د.ك',
    this.orderId = 'ORD-001',
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
          _buildServiceBadge(),
          SizedBox(height: Sizes.s16),
          _buildDistanceRow(),
          SizedBox(height: Sizes.s16),
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
          SizedBox(height: Sizes.s16),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: Sizes.s16),
          _buildPriceRow(),
          SizedBox(height: Sizes.s24),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildServiceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s12,
        vertical: Insets.s8,
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
            size: 18.w,
            color: _isTow ? AppColors.primary : AppColors.gold,
          ),
          SizedBox(width: Insets.s8),
          Text(
            _isTow ? AppStrings.towService : AppStrings.fuelService,
            style: getSemiBoldStyle(
              color: _isTow ? AppColors.primary : AppColors.gold,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceRow() {
    return Row(
      children: [
        Icon(
          Icons.near_me_outlined,
          size: 18.w,
          color: AppColors.grey,
        ),
        SizedBox(width: Insets.s8),
        Text(
          '${AppStrings.distanceAway} $distance ${AppStrings.km}',
          style: getRegularStyle(
            color: AppColors.grey,
            fontSize: FontSize.s14,
          ),
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
        Text(
          'السعر المتوقع',
          style: getRegularStyle(
            color: AppColors.grey,
            fontSize: FontSize.s14,
          ),
        ),
        Text(
          estimatedPrice,
          style: getBoldStyle(
            color: AppColors.primary,
            fontSize: FontSize.s18,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: AppStrings.orderDetails,
            isOutlined: true,
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.driverOrderDetails,
                arguments: DriverOrderDetailsArgs(
                  orderId: orderId,
                  serviceType: serviceType,
                  customerName: 'أحمد محمد',
                  customerPhone: '+965 5555 1234',
                  pickupAddress: pickupAddress,
                  deliveryAddress: deliveryAddress,
                  carType: 'تويوتا كامري 2022',
                  plateNumber: 'أ ب م - 3541',
                  distance: distance,
                  amount: 150.0,
                  paymentMethod: 'كاش',
                ),
              );
            },
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: AppButton(
            text: AppStrings.acceptOrder,
            onPressed: () => _showAcceptDialog(context),
          ),
        ),
      ],
    );
  }

  void _showAcceptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        title: Text(
          AppStrings.acceptOrder,
          style: getBoldStyle(
            color: AppColors.darkGrey,
            fontSize: FontSize.s18,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من قبول هذا الطلب؟',
          style: getRegularStyle(
            color: AppColors.grey,
            fontSize: FontSize.s14,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppStrings.cancel,
              style: getMediumStyle(
                color: AppColors.grey,
                fontSize: FontSize.s14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // close bottom sheet
              Navigator.of(context).pushNamed(
                Routes.driverNavigate,
                arguments: DriverNavigateArgs(
                  orderId: orderId,
                  address: pickupAddress,
                  navigationType: 'toCustomer',
                ),
              );
            },
            child: Text(
              AppStrings.confirm,
              style: getBoldStyle(
                color: AppColors.primary,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
