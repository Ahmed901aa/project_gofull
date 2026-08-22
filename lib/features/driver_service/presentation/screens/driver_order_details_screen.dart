import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/confirm_acceptance_dialog.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class DriverOrderDetailsScreen extends StatelessWidget {
  final DriverOrderDetailsArgs args;
  const DriverOrderDetailsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.colors.background,
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
                    _buildCustomerInfo(context),
                    SizedBox(height: Insets.s16),
                    _buildTripRoute(context),
                    SizedBox(height: Insets.s16),
                    if (args.customerNotes != null &&
                        args.customerNotes!.isNotEmpty) ...[
                      _buildCustomerNotes(context),
                      SizedBox(height: Insets.s16),
                    ],
                    _buildPaymentSummary(context),
                    SizedBox(height: Insets.s24),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      );
  }

  // ── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
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
                    child: Icon(backArrowIcon(context),
                        size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).orderDetails,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: context.colors.textPrimary),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );

  // ── Customer Info ───────────────────────────────────────────

  Widget _buildCustomerInfo(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).customerInfo,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),
            Row(
              children: [
                // Avatar
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: context.colors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded,
                      size: 28.sp, color: context.colors.primary),
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
                            color: context.colors.textPrimary,
                            fontSize: FontSize.s16),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        args.customerPhone,
                        style: getRegularStyle(
                            color: context.colors.textSecondary,
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
                      color: context.colors.primarySurface,
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                    ),
                    child: Icon(Icons.phone_rounded,
                        size: 20.sp, color: context.colors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // ── Trip Route ──────────────────────────────────────────────

  Widget _buildTripRoute(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).tripRoute,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),

            // Pickup point
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: context.colors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.my_location_rounded,
                      size: 18.sp, color: context.colors.primary),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).departurePoint,
                        style: getRegularStyle(
                            color: context.colors.textSecondary,
                            fontSize: FontSize.s12),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        args.pickupAddress,
                        style: getMediumStyle(
                            color: context.colors.textPrimary,
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
              padding: EdgeInsetsDirectional.only(end: 17.w),
              child: Column(
                children: List.generate(
                  3,
                  (_) => Container(
                    width: 2.w,
                    height: 6.h,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    color: context.colors.border,
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
                  decoration: BoxDecoration(
                    color: context.colors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on_rounded,
                      size: 18.sp, color: context.colors.primary),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).deliveryDestination,
                        style: getRegularStyle(
                            color: context.colors.textSecondary,
                            fontSize: FontSize.s12),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        args.deliveryAddress,
                        style: getMediumStyle(
                            color: context.colors.textPrimary,
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
                    color: context.colors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Text(
                    '${args.distance.toStringAsFixed(1)} ${S.of(context).km}',
                    style: getMediumStyle(
                        color: context.colors.primary, fontSize: FontSize.s12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // ── Customer Notes ──────────────────────────────────────────

  Widget _buildCustomerNotes(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).customerNotes,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Insets.s12),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.inputBorder),
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Text(
                args.customerNotes!,
                style: getRegularStyle(
                    color: context.colors.textPrimary, fontSize: FontSize.s14),
              ),
            ),
          ],
        ),
      );

  // ── Payment Summary ─────────────────────────────────────────

  Widget _buildPaymentSummary(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).paymentSummaryLabel,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).totalAmount,
                      style: getMediumStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s16),
                    ),
                    SizedBox(width: Insets.s8),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s8, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: context.colors.primarySurface,
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Text(
                        args.paymentMethod ?? S.of(context).cashPayment,
                        style: getMediumStyle(
                            color: context.colors.primary, fontSize: FontSize.s12),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${args.amount.toStringAsFixed(2)} ${S.of(context).currencyEGP}',
                  style: getBoldStyle(
                      color: context.colors.primary, fontSize: FontSize.s18),
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
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border(top: BorderSide(color: context.colors.borderSubtle)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Accept order
            AppButton(
              text: S.of(context).acceptOrder,
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
                  side: BorderSide(color: context.colors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                ),
                child: Text(
                  S.of(context).rejectOrder,
                  style: getSemiBoldStyle(
                      color: context.colors.error, fontSize: FontSize.s16),
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
