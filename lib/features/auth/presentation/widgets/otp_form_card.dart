import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'otp_input_field.dart';
import 'otp_resend_row.dart';

class OtpFormCard extends StatefulWidget {
  final String phoneNumber;
  final bool isLoading;
  final VoidCallback onChangeNumber;
  final ValueChanged<String> onConfirm;

  const OtpFormCard({
    super.key,
    required this.phoneNumber,
    required this.onChangeNumber,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  State<OtpFormCard> createState() => _OtpFormCardState();
}

class _OtpFormCardState extends State<OtpFormCard> {
  int _seconds = 60;
  Timer? _timer;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) { t.cancel(); return; }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime =>
      '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';

  String get _maskedPhone {
    final phone = widget.phoneNumber;
    if (phone.length <= 5) return phone;
    final prefix = phone.substring(0, 3);
    final suffix = phone.substring(phone.length - 2);
    final masked = 'x' * (phone.length - 5);
    return '$prefix$masked$suffix';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Insets.s24, vertical: Insets.s32),
      child: Column(
        children: [
          Text(AppStrings.otpTitle, textAlign: TextAlign.center, style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s24)),
          SizedBox(height: Sizes.s12),
          Text('${AppStrings.otpSubtitle} $_maskedPhone', textAlign: TextAlign.center, style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
          SizedBox(height: Sizes.s8),
          GestureDetector(
            onTap: widget.onChangeNumber,
            child: Text(AppStrings.changeNumber, style: getSemiBoldStyle(color: AppColors.primary, fontSize: FontSize.s14)),
          ),
          SizedBox(height: Sizes.s32),
          OtpInputField(onCompleted: (code) => _otpCode = code),
          SizedBox(height: Sizes.s24),
          OtpResendRow(
            seconds: _seconds,
            formattedTime: _formattedTime,
            onResend: () => setState(() { _seconds = 60; _startTimer(); }),
          ),
          SizedBox(height: Sizes.s32),
          AppButton(text: AppStrings.confirm, isLoading: widget.isLoading, onPressed: () => widget.onConfirm(_otpCode)),
        ],
      ),
    );
  }
}
