import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

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
    final serviceLabel = isFuel ? S.of(context).fuelService : S.of(context).towService;
    final address = req?.driverAddress ?? S.of(context).customerAddress;
    final plateNumber = req?.plateNumber ?? '';

    // Extract real customer info from driverInfo (populated by backend `with('driver')`)
    final driverInfo = req?.driverInfo ?? {};
    final rawName = driverInfo['name'] as String?;
    final customerName = (rawName != null && rawName.isNotEmpty) ? rawName : S.of(context).customerDefault;
    final customerPhone = driverInfo['phone'] as String?;

    // Debug log (visible in `flutter logs`)
    developer.log(
      'OrderPopupCard — request #${req?.id}, driverInfo: $driverInfo, name="$rawName"',
      name: 'OrderPopupCard',
    );

    final fuelInfo = isFuel
        ? '${req?.fuelType ?? ''} - ${req?.fuelQuantity ?? ''} ${S.of(context).litersUnit}'
        : '';

    return Container(
        margin: EdgeInsets.symmetric(horizontal: Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
          boxShadow: [
            BoxShadow(color: context.colors.shadow, blurRadius: 20, offset: const Offset(0, -4)),
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
                decoration: BoxDecoration(color: context.colors.border, borderRadius: BorderRadius.circular(2.r)),
              ),

              // Top row: customer name (right in RTL = "start") + service badge (left in RTL = "end" visually top-right in original direction)
              // In RTL layout: Row start = right side of screen. Use Align to push badge to top-right.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer avatar + name (right side in RTL)
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_rounded, size: 22.sp, color: context.colors.primary),
                  ),
                  SizedBox(width: Insets.s8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: getBoldStyle(fontSize: FontSize.s16, color: context.colors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          customerPhone ?? S.of(context).newOrderLabel,
                          style: getRegularStyle(fontSize: FontSize.s12, color: context.colors.iconSecondary),
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                  // Service type badge — positioned in top-right (= end of RTL row)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isFuel
                          ? context.colors.successSurface
                          : context.colors.warningSurface,
                      borderRadius: BorderRadius.circular(AppRadius.s16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DirectionalServiceIcon(
                          isFuel ? Icons.local_gas_station : Icons.local_shipping_outlined,
                          size: 14.sp,
                          color: isFuel ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          serviceLabel,
                          style: getSemiBoldStyle(
                            fontSize: FontSize.s12,
                            color: isFuel ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: Insets.s16),
              Divider(color: context.colors.divider, height: 1),
              SizedBox(height: Insets.s12),

              // Address
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18.sp, color: context.colors.primary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      address,
                      style: getMediumStyle(fontSize: FontSize.s14, color: context.colors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              if (isFuel && fuelInfo.isNotEmpty) ...[
                SizedBox(height: Insets.s8),
                Row(
                  children: [
                    Icon(Icons.local_gas_station, size: 18.sp, color: context.colors.iconSecondary),
                    SizedBox(width: 6.w),
                    Text(fuelInfo, style: getRegularStyle(fontSize: FontSize.s14, color: context.colors.textSecondary)),
                  ],
                ),
              ],

              if (plateNumber.isNotEmpty) ...[
                SizedBox(height: Insets.s8),
                Row(
                  children: [
                    Icon(Icons.directions_car_outlined, size: 18.sp, color: context.colors.iconSecondary),
                    SizedBox(width: 6.w),
                    Text(plateNumber, style: getMediumStyle(fontSize: FontSize.s14, color: context.colors.textPrimary)),
                  ],
                ),
              ],

              if (req?.notes != null && req!.notes!.isNotEmpty) ...[
                SizedBox(height: Insets.s8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.sticky_note_2_outlined, size: 18.sp, color: context.colors.iconSecondary),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        req.notes!,
                        style: getRegularStyle(fontSize: FontSize.s12, color: context.colors.iconSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: Insets.s16),
              Divider(color: context.colors.divider, height: 1),
              SizedBox(height: Insets.s12),

              // Action buttons
              Row(
                children: [
                  SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: widget.onReject,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.colors.error),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
                        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      ),
                      child: Text(S.of(context).rejectOrder, style: getSemiBoldStyle(fontSize: FontSize.s14, color: context.colors.error)),
                    ),
                  ),
                  SizedBox(width: Insets.s12),
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: widget.onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
                          elevation: 0,
                        ),
                        child: Text('${S.of(context).acceptOrder} ($_secondsLeft ${S.of(context).secondsAbbrev})', style: getSemiBoldStyle(fontSize: FontSize.s16, color: context.colors.surface)),
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
