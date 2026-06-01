import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class OrderAddressColumn extends StatelessWidget {
  final String label;
  final String address;

  const OrderAddressColumn({super.key, required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12),
        ),
        SizedBox(height: 2.h),
        Text(
          address,
          style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
