import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class OrderPriceRow extends StatelessWidget {
  final String price;

  const OrderPriceRow({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Insets.s16, right: Insets.s16, bottom: Insets.s12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(price, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
                decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(AppRadius.s16)),
                child: Text('كاش', style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s12)),
              ),
              SizedBox(width: 6.w),
              Text('الإجمالي', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16)),
            ],
          ),
        ],
      ),
    );
  }
}
