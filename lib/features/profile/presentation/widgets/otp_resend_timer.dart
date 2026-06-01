import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class OtpResendTimer extends StatelessWidget {
  final int seconds;
  final VoidCallback onResend;
  const OtpResendTimer({super.key, required this.seconds, required this.onResend});

  String get _formattedTime =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14).copyWith(height: 1.4),
        children: [
          TextSpan(text: S.of(context).didntReceiveCode),
          seconds == 0
              ? WidgetSpan(child: GestureDetector(
                  onTap: onResend,
                  child: Text(S.of(context).resendCode, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
                ))
              : TextSpan(text: '${S.of(context).resendCode} $_formattedTime', style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s14).copyWith(height: 1.4)),
        ],
      ),
    );
  }
}

class OtpConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;
  const OtpConfirmButton({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h, width: double.infinity,
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
        child: Text(S.of(context).confirm, style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s16).copyWith(height: 1.6)),
      ),
    );
  }
}
