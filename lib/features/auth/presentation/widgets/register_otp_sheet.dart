import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/profile/presentation/widgets/otp_input_box.dart';
import 'package:project_gofull/features/profile/presentation/widgets/otp_resend_timer.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Bottom sheet for entering the 6-digit SMS registration code.
///
/// Pops with the entered code (String) on confirm, or null when dismissed.
/// [onResend] re-requests a code (the resend timer restarts).
class RegisterOtpSheet extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onResend;

  const RegisterOtpSheet({
    super.key,
    required this.phoneNumber,
    required this.onResend,
  });

  static Future<String?> show(
    BuildContext context,
    String phoneNumber, {
    required VoidCallback onResend,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          RegisterOtpSheet(phoneNumber: phoneNumber, onResend: onResend),
    );
  }

  @override
  State<RegisterOtpSheet> createState() => _RegisterOtpSheetState();
}

class _RegisterOtpSheetState extends State<RegisterOtpSheet> {
  static const int _codeLength = 6;
  static const int _resendSeconds = 60;

  final _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  int _seconds = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNodes[0].requestFocus());
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_seconds == 0) {
        t.cancel();
        return;
      }
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int i, String v) {
    if (v.length == 1 && i < _codeLength - 1) {
      _focusNodes[i + 1].requestFocus();
    }
    if (v.isEmpty && i > 0) {
      _focusNodes[i - 1].requestFocus();
    }
    // Auto-confirm once all digits are entered
    if (_code.length == _codeLength) {
      _confirm();
    }
  }

  void _confirm() {
    final code = _code;
    if (code.length != _codeLength) {
      return;
    }
    Navigator.of(context).pop(code);
  }

  void _resend() {
    widget.onResend();
    _startTimer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s16, Insets.s16, Insets.s12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${S.of(context).enterSmsCode}${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: getMediumStyle(
                    color: context.colors.textPrimary, fontSize: FontSize.s14),
              ),
              SizedBox(height: Sizes.s16),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _codeLength,
                    (i) => OtpInputBox(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      width: 44,
                      onChanged: (v) => _onChanged(i, v),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Sizes.s16),
              OtpResendTimer(seconds: _seconds, onResend: _resend),
              SizedBox(height: Sizes.s16),
              OtpConfirmButton(onConfirm: _confirm),
            ],
          ),
        ),
      ),
    );
  }
}
