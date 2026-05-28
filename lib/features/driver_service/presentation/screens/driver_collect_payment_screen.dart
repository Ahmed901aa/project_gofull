import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverCollectPaymentScreen extends StatelessWidget {
  final DriverCollectPaymentArgs args;
  const DriverCollectPaymentScreen({super.key, required this.args});

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
                    _buildInstructionsCard(context),
                    SizedBox(height: Insets.s24),
                    _buildAmountSection(context),
                    SizedBox(height: Insets.s24),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context),
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
                      S.of(context).collectPayment,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final phone = args.customerPhone;
                      if (phone != null && phone.isNotEmpty) {
                        launchUrl(Uri.parse('tel:$phone'));
                      }
                    },
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.phone_rounded,
                          size: 20.sp, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  // ── Instructions Card ───────────────────────────────────────

  Widget _buildInstructionsCard(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_rounded,
                    size: 22.sp, color: AppColors.primary),
                SizedBox(width: Insets.s8),
                Text(
                  S.of(context).collectionInstructions,
                  style: getBoldStyle(
                      color: AppColors.primary, fontSize: FontSize.s14),
                ),
              ],
            ),
            SizedBox(height: Insets.s12),
            _buildBulletPoint(S.of(context).confirmFullAmount),
            SizedBox(height: Insets.s8),
            _buildBulletPoint(S.of(context).cashOnly),
          ],
        ),
      );

  Widget _buildBulletPoint(String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: Insets.s8),
          Expanded(
            child: Text(
              text,
              style: getRegularStyle(
                  color: AppColors.primaryLight, fontSize: FontSize.s14),
            ),
          ),
        ],
      );

  // ── Amount Section ──────────────────────────────────────────

  Widget _buildAmountSection(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).requiredAmount,
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          ),
          SizedBox(height: Insets.s12),
          Container(
            padding: EdgeInsets.all(Insets.s20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.s12),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).totalAmount,
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
                        borderRadius:
                            BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Text(
                        args.paymentMethod,
                        style: getMediumStyle(
                            color: AppColors.primary,
                            fontSize: FontSize.s12),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${args.amount.toStringAsFixed(2)} ${S.of(context).currencyEGP}',
                  style: getBoldStyle(
                      color: AppColors.primary, fontSize: FontSize.s24),
                ),
              ],
            ),
          ),
        ],
      );

  // ── Bottom Button ───────────────────────────────────────────

  Widget _buildBottomButton(BuildContext context) => Container(
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
        child: AppButton(
          text: S.of(context).confirmReceived,
          onPressed: () {
            // Update status to 'completed'
            final orderId = int.tryParse(args.orderId);
            if (orderId != null) {
              sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'completed'));
            }
            Navigator.pushReplacementNamed(
              context,
              Routes.driverTaskComplete,
              arguments: DriverTaskCompleteArgs(
                orderId: args.orderId,
                earnings: args.amount,
              ),
            );
          },
        ),
      );
}
