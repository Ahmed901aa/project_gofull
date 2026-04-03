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

class DriverTaskCompleteScreen extends StatelessWidget {
  final DriverTaskCompleteArgs args;
  const DriverTaskCompleteScreen({super.key, required this.args});

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
                    SizedBox(height: Sizes.s40),
                    _buildSuccessIcon(),
                    SizedBox(height: Insets.s24),
                    _buildSuccessText(),
                    SizedBox(height: Sizes.s32),
                    _buildEarningsCard(),
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
                    onTap: () => Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name == Routes.driverHome ||
                            route.isFirst),
                    child: Icon(Icons.close_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.taskComplete,
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

  // ── Success Icon ────────────────────────────────────────────

  Widget _buildSuccessIcon() => Center(
        child: Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.verified_rounded,
            size: 60.sp,
            color: AppColors.success,
          ),
        ),
      );

  // ── Success Text ────────────────────────────────────────────

  Widget _buildSuccessText() => Column(
        children: [
          Text(
            AppStrings.orderCompletedSuccess,
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s22),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.s8),
          Text(
            AppStrings.earningsRecorded,
            style: getRegularStyle(
                color: AppColors.neutral800, fontSize: FontSize.s14),
            textAlign: TextAlign.center,
          ),
        ],
      );

  // ── Earnings Card ───────────────────────────────────────────

  Widget _buildEarningsCard() => Container(
        padding: EdgeInsets.all(Insets.s20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              AppStrings.addedEarnings,
              style: getMediumStyle(
                  color: AppColors.neutral800, fontSize: FontSize.s14),
            ),
            SizedBox(height: Insets.s8),
            Text(
              '${args.earnings.toStringAsFixed(2)} ج.م',
              style: getBoldStyle(
                  color: AppColors.primary, fontSize: FontSize.s28),
            ),
          ],
        ),
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
          text: AppStrings.rateCustomer,
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              Routes.driverRateCustomer,
              arguments: DriverRateArgs(orderId: args.orderId),
            );
          },
        ),
      );
}
