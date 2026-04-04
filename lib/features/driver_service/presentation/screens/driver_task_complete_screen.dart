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

class DriverTaskCompleteScreen extends StatelessWidget {
  final DriverTaskCompleteArgs args;
  const DriverTaskCompleteScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: AppStrings.taskComplete),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  _buildSuccessIcon(),
                  SizedBox(height: Sizes.s24),
                  _buildSuccessText(),
                  SizedBox(height: Sizes.s32),
                  _buildEarningsCard(),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 70.w,
          height: 70.w,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 40.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessText() {
    return Column(
      children: [
        Text(
          AppStrings.orderCompletedSuccess,
          style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s8),
        Text(
          AppStrings.earningsRecorded,
          style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Insets.s20, horizontal: Insets.s16),
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
          Text(
            AppStrings.addedEarnings,
            style: getMediumStyle(color: AppColors.grey, fontSize: FontSize.s14),
          ),
          SizedBox(height: Insets.s8),
          Text(
            '${args.earnings.toStringAsFixed(0)} د.ك',
            style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s28),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s24),
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
        text: AppStrings.rateCustomer,
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.driverRateCustomer,
            arguments: DriverRateArgs(
              orderId: args.orderId,
            ),
          );
        },
      ),
    );
  }
}
