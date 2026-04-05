import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class EtaBottomPanel extends StatelessWidget {
  final String etaFormatted;
  final double progress;
  final String? label;
  const EtaBottomPanel({super.key, required this.etaFormatted, required this.progress, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          label ?? 'الوقت المتوقع للوصول: $etaFormatted دقيقة',
          style: getSemiBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: Insets.s8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.s16),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.neutral600,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6.h,
          ),
        ),
        SizedBox(height: Insets.s16),
        Row(children: [
          Expanded(child: _ActionButton(label: 'اتصال بالسائق', icon: Icons.call_rounded)),
          SizedBox(width: Insets.s12),
          Expanded(child: _ActionButton(label: 'إرسال رسالة', icon: Icons.chat_bubble_outline_rounded)),
        ]),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ActionButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: () {}, // placeholder — wire up with real call/chat later
        icon: Icon(icon, size: 20.sp, color: AppColors.primary),
        label: Text(label, style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s16)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
        ),
      ),
    );
  }
}
