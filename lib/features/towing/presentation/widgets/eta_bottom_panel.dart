import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class EtaBottomPanel extends StatelessWidget {
  final String etaFormatted;
  final double progress;
  final String? label;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  const EtaBottomPanel({
    super.key,
    required this.etaFormatted,
    required this.progress,
    this.label,
    this.onCall,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: context.colors.border.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          label ?? S.of(context).etaLabel(etaFormatted),
          style: getSemiBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.s16),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: context.colors.border,
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
            minHeight: 6.h,
          ),
        ),
        SizedBox(height: Insets.s16),
        Row(children: [
          Expanded(
            child: _ActionButton(
              label: S.of(context).callDriver,
              icon: Icons.call_rounded,
              onPressed: onCall,
            ),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: _ActionButton(
              label: S.of(context).sendMessage,
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: onMessage,
            ),
          ),
        ]),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  const _ActionButton({required this.label, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20.sp, color: context.colors.primary),
        label: Text(label, style: getBoldStyle(color: context.colors.primary, fontSize: FontSize.s16)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.colors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
        ),
      ),
    );
  }
}
