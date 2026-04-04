import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';

class DriverCollectPaymentScreen extends StatelessWidget {
  final DriverCollectPaymentArgs args;
  const DriverCollectPaymentScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: 'تحصيل مبلغ الخدمة'),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Sizes.s24),
                  _buildAmountDisplay(),
                  SizedBox(height: Sizes.s32),
                  _buildInstructionsCard(),
                  SizedBox(height: Sizes.s24),
                  _buildPaymentMethodRow(),
                  SizedBox(height: Sizes.s48),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay() {
    return Column(
      children: [
        Text(
          'المبلغ المطلوب تحصيله',
          style: getMediumStyle(color: AppColors.grey, fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s12),
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.payments_outlined,
            size: 44.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: Insets.s16),
        Text(
          '${args.amount.toStringAsFixed(0)} ج.م',
          style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s28),
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border(
          right: BorderSide(
            color: AppColors.primary,
            width: 4.w,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 20.sp, color: AppColors.primary),
              SizedBox(width: Insets.s8),
              Text(
                'تعليمات التحصيل',
                style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
              ),
            ],
          ),
          SizedBox(height: Insets.s12),
          _buildBulletPoint('تأكد من استلام المبلغ كاملاً قبل التأكيد'),
          SizedBox(height: Insets.s8),
          _buildBulletPoint('الدفع نقداً فقط'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
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
            style: getRegularStyle(color: AppColors.darkGrey, fontSize: FontSize.s14),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow() {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'طريقة الدفع',
            style: getMediumStyle(color: AppColors.grey, fontSize: FontSize.s14),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.s12,
              vertical: Insets.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.s24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.money_rounded, size: 18.sp, color: AppColors.primary),
                SizedBox(width: Insets.s4),
                Text(
                  'كاش',
                  style: getMediumStyle(
                    color: AppColors.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
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
        text: 'تأكيد استلام المبلغ',
        onPressed: () {
          Navigator.pushNamed(
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
}
