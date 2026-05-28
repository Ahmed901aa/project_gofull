import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'otp_input_box.dart';
import 'otp_resend_timer.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PhoneOtpBottomSheet extends StatefulWidget {
  final String phoneNumber;
  const PhoneOtpBottomSheet({super.key, required this.phoneNumber});

  static Future<bool?> show(BuildContext context, String phoneNumber) {
    return showModalBottomSheet<bool>(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => PhoneOtpBottomSheet(phoneNumber: phoneNumber));
  }

  @override
  State<PhoneOtpBottomSheet> createState() => _PhoneOtpBottomSheetState();
}

class _PhoneOtpBottomSheetState extends State<PhoneOtpBottomSheet> {
  final _controllers = List.generate(5, (_) => TextEditingController());
  final _focusNodes = List.generate(5, (_) => FocusNode());
  int _seconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNodes[0].requestFocus());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) { t.cancel(); return; }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _maskedPhone {
    final p = widget.phoneNumber;
    if (p.length <= 5) return p;
    return '${p.substring(0, 3)}${'x' * (p.length - 5)}${p.substring(p.length - 2)}';
  }

  void _onChanged(int i, String v) {
    if (v.length == 1 && i < 4) _focusNodes[i + 1].requestFocus();
    if (v.isEmpty && i > 0) _focusNodes[i - 1].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16))),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s16, Insets.s16, Insets.s12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(S.of(context).confirmNewNumber, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20).copyWith(height: 1.6), textAlign: TextAlign.center),
              SizedBox(height: Insets.s8),
              RichText(textAlign: TextAlign.center, text: TextSpan(
                style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s14).copyWith(height: 1.4),
                children: [
                  TextSpan(text: S.of(context).enterSmsCode),
                  TextSpan(text: _maskedPhone, style: getMediumStyle(color: context.colors.textSecondary, fontSize: FontSize.s14).copyWith(height: 1.4)),
                ],
              )),
              SizedBox(height: Insets.s8),
              GestureDetector(onTap: () => Navigator.pop(context, false),
                child: Text(S.of(context).changeNumber, style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s14).copyWith(decoration: TextDecoration.underline, height: 1.4), textAlign: TextAlign.center)),
              SizedBox(height: Insets.s24),
              Directionality(textDirection: TextDirection.ltr,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => OtpInputBox(controller: _controllers[i], focusNode: _focusNodes[i], onChanged: (v) => _onChanged(i, v))))),
              SizedBox(height: Insets.s24),
              OtpResendTimer(seconds: _seconds, onResend: () => setState(() { _seconds = 60; _startTimer(); })),
              SizedBox(height: Insets.s24),
              OtpConfirmButton(onConfirm: () => Navigator.pop(context, true)),
            ]),
          ),
        ),
      );
  }
}
