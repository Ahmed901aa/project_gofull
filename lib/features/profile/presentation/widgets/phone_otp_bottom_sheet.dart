import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class PhoneOtpBottomSheet extends StatefulWidget {
  final String phoneNumber;

  const PhoneOtpBottomSheet({super.key, required this.phoneNumber});

  /// Returns `true` if verification succeeded.
  static Future<bool?> show(BuildContext context, String phoneNumber) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PhoneOtpBottomSheet(phoneNumber: phoneNumber),
    );
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
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

  String get _formattedTime =>
      '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';

  String get _maskedPhone {
    final p = widget.phoneNumber;
    if (p.length <= 5) return p;
    return '${p.substring(0, 3)}${'x' * (p.length - 5)}${p.substring(p.length - 2)}';
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 4) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _confirm() {
    // replace with API later
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
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
                  'تأكيد الرقم الجديد',
                  style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20).copyWith(height: 1.6),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Insets.s8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14).copyWith(height: 1.4),
                    children: [
                      const TextSpan(text: 'دخل الكود اللي بعتناه في رسالة نصية (SMS) على الرقم '),
                      TextSpan(
                        text: _maskedPhone,
                        style: getMediumStyle(color: const Color(0xFF646565), fontSize: FontSize.s14).copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Insets.s8),
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Text(
                    'تغيير الرقم',
                    style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(
                      decoration: TextDecoration.underline,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Insets.s24),

                // OTP boxes
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) => _buildOtpBox(i)),
                  ),
                ),
                SizedBox(height: Insets.s24),

                // Resend timer
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14).copyWith(height: 1.4),
                    children: [
                      const TextSpan(text: 'لم يصلك الكود؟ '),
                      _seconds == 0
                          ? WidgetSpan(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _seconds = 60;
                                  _startTimer();
                                }),
                                child: Text(
                                  'إعادة الإرسال',
                                  style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                                ),
                              ),
                            )
                          : TextSpan(
                              text: 'إعادة الإرسال خلال $_formattedTime',
                              style: getMediumStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14).copyWith(height: 1.4),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: Insets.s24),

                // Confirm button
                SizedBox(
                  height: 48.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004B3B),
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                      elevation: 0,
                    ),
                    child: Text(
                      'تأكيد',
                      style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16).copyWith(height: 1.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 56.w,
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: 20.sp),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (v) => _onChanged(index, v),
      ),
    );
  }
}
