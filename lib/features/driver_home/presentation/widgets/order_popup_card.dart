import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class OrderPopupCard extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const OrderPopupCard({
    super.key,
    required this.onAccept,
    required this.onReject,
  });

  @override
  State<OrderPopupCard> createState() => _OrderPopupCardState();
}

class _OrderPopupCardState extends State<OrderPopupCard> {
  int _secondsLeft = 16;
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.s24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Insets.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: Insets.s12),
              decoration: BoxDecoration(
                color: AppColors.neutral600,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Service type badge + distance
            Row(
              children: [
                // Distance (left in RTL = visually left)
                Text(
                  '${AppStrings.distanceAway} 3.5 ${AppStrings.km}',
                  style: getRegularStyle(
                    fontSize: FontSize.s12,
                    color: AppColors.grey,
                  ),
                ),
                const Spacer(),
                // Service badge (right in RTL = visually right)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s12,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.towService,
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s12,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: Insets.s16),

            // Route: pickup + delivery with dotted line
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dotted line with dots
                  Column(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                        ),
                      ),
                      Expanded(
                        child: CustomPaint(
                          painter: _DottedLinePainter(color: AppColors.grey),
                          size: Size(1.w, double.infinity),
                        ),
                      ),
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: Insets.s12),
                  // Addresses
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.departurePoint,
                              style: getRegularStyle(
                                fontSize: FontSize.s12,
                                color: AppColors.grey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'شارع التحلية، حي العليا، الرياض',
                              style: getMediumStyle(
                                fontSize: FontSize.s14,
                                color: AppColors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(height: Insets.s12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.deliveryDestination,
                              style: getRegularStyle(
                                fontSize: FontSize.s12,
                                color: AppColors.grey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'ورشة الأمانة، حي السلام، الرياض',
                              style: getMediumStyle(
                                fontSize: FontSize.s14,
                                color: AppColors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Insets.s16),

            // Divider
            const Divider(color: AppColors.divider, height: 1),

            SizedBox(height: Insets.s12),

            // Car type + plate number
            Row(
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  size: 18.sp,
                  color: AppColors.grey,
                ),
                SizedBox(width: 6.w),
                Text(
                  'تويوتا كامري',
                  style: getMediumStyle(
                    fontSize: FontSize.s14,
                    color: AppColors.black,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s8,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral400,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Text(
                    'ب ك م  1234',
                    style: getMediumStyle(
                      fontSize: FontSize.s12,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: Insets.s16),

            // Action buttons
            Row(
              children: [
                // Reject button
                SizedBox(
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: widget.onReject,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.s12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                    ),
                    child: Text(
                      AppStrings.rejectOrder,
                      style: getSemiBoldStyle(
                        fontSize: FontSize.s14,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Insets.s12),
                // Accept button with timer
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.s12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '${AppStrings.acceptOrder} ($_secondsLeft ث)',
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s16,
                          color: AppColors.white,
                        ),
                      ),
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

/// Paints a vertical dotted line between the pickup and delivery dots.
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
    const dashGap = 4.0;
    double startY = 0;
    final centerX = size.width / 2;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(centerX, startY),
        Offset(centerX, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
