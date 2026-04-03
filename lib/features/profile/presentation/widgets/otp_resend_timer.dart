import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
        style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14).copyWith(height: 1.4),
        children: [
          const TextSpan(text: 'لم يصلك الكود؟ '),
          seconds == 0
              ? WidgetSpan(child: GestureDetector(
                  onTap: onResend,
                  child: Text('إعادة الإرسال', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
                ))
              : TextSpan(text: 'إعادة الإرسال خلال $_formattedTime', style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.4)),
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
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004B3B), foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
        child: Text('تأكيد', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16).copyWith(height: 1.6)),
      ),
    );
  }
}
