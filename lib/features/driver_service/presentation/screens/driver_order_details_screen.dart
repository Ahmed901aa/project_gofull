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
import 'package:url_launcher/url_launcher.dart';
import '../widgets/confirm_acceptance_dialog.dart';

class DriverOrderDetailsScreen extends StatelessWidget {
  final DriverOrderDetailsArgs args;
  const DriverOrderDetailsScreen({super.key, required this.args});

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
                  children: [
                    _buildCustomerInfo(),
                    SizedBox(height: Insets.s16),
                    _buildTripRoute(),
                    SizedBox(height: Insets.s16),
                    if (args.customerNotes != null &&
                        args.customerNotes!.isNotEmpty) ...[
                      _buildCustomerNotes(),
                      SizedBox(height: Insets.s16),
                    ],
                    _buildPaymentSummary(),
                    SizedBox(height: Insets.s24),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────

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
                      AppStrings.orderDetails,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: const Color(0xFF0E0E0E)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  // ── Customer Info ───────────────────────────────────────────

  Widget _buildCustomerInfo() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.customerInfo,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),
            Row(
              children: [
                // Avatar
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded,
                      size: 28.sp, color: AppColors.primary),
                ),
                SizedBox(width: Insets.s12),

                // Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        args.customerName,
                        style: getSemiBoldStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s16),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        args.customerPhone,
                        style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s14),
                      ),
                    ],
                  ),
                ),

                // Call button
                GestureDetector(
                  onTap: () =>
                      launchUrl(Uri.parse('tel:${args.customerPhone}')),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                    ),
                    child: Icon(Icons.phone_rounded,
                        size: 20.sp, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // ── Car Photos ──────────────────────────────────────────────

  Widget _buildCarPhotos() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.carPhotos,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: args.carPhotos.isNotEmpty ? args.carPhotos.length : 3,
                separatorBuilder: (_, __) => SizedBox(width: Insets.s8),
                itemBuilder: (_, index) {
                  if (args.carPhotos.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                      child: Image.network(
                        args.carPhotos[index],
                        width: 120.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _photoPlaceholder(),
                      ),
                    );
                  }
                  return _photoPlaceholder();
                },
              ),
            ),
          ],
        ),
      );

  Widget _photoPlaceholder() => Container(
        width: 120.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: AppColors.neutral300,
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Icon(Icons.directions_car_rounded,
            size: 36.sp, color: AppColors.neutral800),
      );

  // ── Trip Route ──────────────────────────────────────────────

  Widget _buildTripRoute() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tripRoute,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),

            // Pickup point
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.my_location_rounded,
                      size: 18.sp, color: AppColors.primary),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.departurePoint,
                        style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s12),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        args.pickupAddress,
                        style: getMediumStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Dotted connector
            Padding(
              padding: EdgeInsets.only(right: 17.w),
              child: Column(
                children: List.generate(
                  3,
                  (_) => Container(
                    width: 2.w,
                    height: 6.h,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    color: AppColors.neutral600,
                  ),
                ),
              ),
            ),

            // Delivery point
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on_rounded,
                      size: 18.sp, color: AppColors.primary),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.deliveryDestination,
                        style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s12),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        args.deliveryAddress,
                        style: getMediumStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.s8, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Text(
                    '${args.distance.toStringAsFixed(1)} ${AppStrings.km}',
                    style: getMediumStyle(
                        color: AppColors.primary, fontSize: FontSize.s12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // ── Customer Notes ──────────────────────────────────────────

  Widget _buildCustomerNotes() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.customerNotes,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Insets.s12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Text(
                args.customerNotes!,
                style: getRegularStyle(
                    color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
              ),
            ),
          ],
        ),
      );

  // ── Payment Summary ─────────────────────────────────────────

  Widget _buildPaymentSummary() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.paymentSummaryLabel,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.totalAmount,
                      style: getMediumStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s16),
                    ),
                    SizedBox(width: Insets.s8),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s8, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Text(
                        args.paymentMethod,
                        style: getMediumStyle(
                            color: AppColors.primary, fontSize: FontSize.s12),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${args.amount.toStringAsFixed(2)} ج.م',
                  style: getBoldStyle(
                      color: AppColors.primary, fontSize: FontSize.s18),
                ),
              ],
            ),
          ],
        ),
      );

  // ── Bottom Buttons ──────────────────────────────────────────

  Widget _buildBottomButtons(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
          Insets.s16,
          Insets.s12,
          Insets.s16,
          Insets.s12 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Accept order
            AppButton(
              text: AppStrings.acceptOrder,
              onPressed: () => _onAcceptTapped(context),
            ),
            SizedBox(height: Insets.s8),

            // Reject order
            SizedBox(
              width: double.infinity,
              height: Sizes.s48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                ),
                child: Text(
                  AppStrings.rejectOrder,
                  style: getSemiBoldStyle(
                      color: AppColors.error, fontSize: FontSize.s16),
                ),
              ),
            ),
          ],
        ),
      );

  // ── Accept flow ─────────────────────────────────────────────

  Future<void> _onAcceptTapped(BuildContext context) async {
    final confirmed = await showConfirmAcceptanceDialog(context);
    if (confirmed == true && context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverNavigate,
        arguments: DriverNavigateArgs(
          orderId: args.orderId,
          address: args.pickupAddress,
          navigationType: 'to_customer',
          serviceType: args.serviceType,
          amount: args.amount,
        ),
      );
    }
  }
}
