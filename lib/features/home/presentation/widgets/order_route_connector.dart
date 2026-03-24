import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';

class OrderRouteConnector extends StatelessWidget {
  const OrderRouteConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w, height: 6.w,
            decoration: BoxDecoration(color: AppColors.neutral600, shape: BoxShape.circle),
          ),
          SizedBox(
            width: 36.w,
            child: Divider(color: AppColors.neutral600, thickness: 1),
          ),
          Container(
            width: 6.w, height: 6.w,
            decoration: BoxDecoration(color: AppColors.neutral600, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
