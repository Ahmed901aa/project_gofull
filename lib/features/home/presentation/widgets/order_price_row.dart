import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class OrderPriceRow extends StatelessWidget {
  final String price;

  const OrderPriceRow({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: Insets.s16, end: Insets.s16, bottom: Insets.s12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(S.of(context).totalAmount, style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s16)),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
                decoration: BoxDecoration(color: context.colors.primarySurface, borderRadius: BorderRadius.circular(AppRadius.s16)),
                child: Text(S.of(context).cashPayment, style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s12)),
              ),
            ],
          ),
          Text(price, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16)),
        ],
      ),
    );
  }
}
