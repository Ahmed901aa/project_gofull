import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';

class OrderAddressColumn extends StatelessWidget {
  final String label;
  final String address;

  const OrderAddressColumn({super.key, required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s12),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 2.h),
        Text(
          address,
          style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s12),
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
