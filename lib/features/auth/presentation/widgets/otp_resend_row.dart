import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';

class OtpResendRow extends StatelessWidget {
  final int seconds;
  final String formattedTime;
  final VoidCallback onResend;

  const OtpResendRow({
    super.key,
    required this.seconds,
    required this.formattedTime,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (seconds > 0)
          Text(
            '${AppStrings.resendIn} $formattedTime',
            style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
          )
        else
          GestureDetector(
            onTap: onResend,
            child: Text(
              AppStrings.resend,
              style: getSemiBoldStyle(color: AppColors.primary, fontSize: FontSize.s14),
            ),
          ),
        Text(
          ' ${AppStrings.noCode}',
          style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
        ),
      ],
    );
  }
}
