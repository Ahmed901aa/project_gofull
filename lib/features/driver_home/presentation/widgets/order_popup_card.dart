import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

class OrderPopupCard extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final ServiceRequestEntity? request;

  const OrderPopupCard({
    super.key,
    required this.onAccept,
    required this.onReject,
    this.request,
  });

  @override
  State<OrderPopupCard> createState() => _OrderPopupCardState();
}

class _OrderPopupCardState extends State<OrderPopupCard> {
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        widget.onReject();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final isFuel = req?.isFuelDelivery ?? false;
    final serviceLabel = isFuel ? AppStrings.fuelService : AppStrings.towService;
    final address = req?.driverAddress ?? 'عنوان العميل';
    final plateNumber = req?.plateNumber ?? '';
    final fuelInfo = isFuel
        ? '${req?.fuelType ?? ''} - ${req?.fuelQuantity ?? ''} لتر'
        : '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Insets.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w, height: 4.h,
              margin: EdgeInsets.only(bottom: Insets.s12),
              decoration: BoxDecoration(color: AppColors.neutral600, borderRadius: BorderRadius.circular(2.r)),
            ),

            // Service type badge
            Row(
              children: [
                if (req?.notes != null && req!.notes!.isNotEmpty)
                  Flexible(
                    child: Text(req.notes!, style: getRegularStyle(fontSize: FontSize.s12, color: AppColors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isFuel ? Icons.local_gas_station : Icons.local_shipping_outlined, size: 16.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(serviceLabel, style: getSemiBoldStyle(fontSize: FontSize.s12, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: Insets.s16),

            // Address
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 18.sp, color: AppColors.primary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(address, style: getMediumStyle(fontSize: FontSize.s14, color: AppColors.black), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),

            if (isFuel && fuelInfo.isNotEmpty) ...[
              SizedBox(height: Insets.s8),
              Row(
                children: [
                  Icon(Icons.local_gas_station, size: 18.sp, color: AppColors.grey),
                  SizedBox(width: 6.w),
                  Text(fuelInfo, style: getRegularStyle(fontSize: FontSize.s14, color: AppColors.darkGrey)),
                ],
              ),
            ],

            if (plateNumber.isNotEmpty) ...[
              SizedBox(height: Insets.s8),
              Row(
                children: [
                  Icon(Icons.directions_car_outlined, size: 18.sp, color: AppColors.grey),
                  SizedBox(width: 6.w),
                  Text(plateNumber, style: getMediumStyle(fontSize: FontSize.s14, color: AppColors.black)),
                ],
              ),
            ],

            SizedBox(height: Insets.s16),
            const Divider(color: AppColors.divider, height: 1),
            SizedBox(height: Insets.s12),

            // Action buttons
            Row(
              children: [
                SizedBox(
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: widget.onReject,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                    ),
                    child: Text(AppStrings.rejectOrder, style: getSemiBoldStyle(fontSize: FontSize.s14, color: AppColors.error)),
                  ),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
                        elevation: 0,
                      ),
                      child: Text('${AppStrings.acceptOrder} ($_secondsLeft ث)', style: getSemiBoldStyle(fontSize: FontSize.s16, color: AppColors.white)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.s8),
          ],
        ),
      ),
    );
  }
}
