import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class SearchingBottomPanel extends StatelessWidget {
  final int secondsLeft;
  final Animation<double> progressAnimation;

  const SearchingBottomPanel({
    super.key,
    required this.secondsLeft,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final mm = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (secondsLeft % 60).toString().padLeft(2, '0');
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: context.colors.border.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: S.of(context).expectedTimeFindDriver, style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
              TextSpan(text: S.of(context).minutesFormatted('$mm:$ss'), style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
            ]),
          ),
          SizedBox(height: Insets.s8),
          AnimatedBuilder(
            animation: progressAnimation,
            builder: (_, __) => Container(
              height: 6.h,
              decoration: BoxDecoration(color: context.colors.border, borderRadius: BorderRadius.circular(AppRadius.s16)),
              child: FractionallySizedBox(
                widthFactor: progressAnimation.value,
                alignment: AlignmentDirectional.centerEnd,
                child: Container(decoration: BoxDecoration(color: context.colors.primary, borderRadius: BorderRadius.circular(AppRadius.s16))),
              ),
            ),
          ),
          SizedBox(height: Insets.s16),
          SizedBox(
            height: 48.h, width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close_rounded, size: 20.sp, color: context.colors.primary),
              label: Text(S.of(context).cancelOrder, style: getBoldStyle(color: context.colors.primary, fontSize: FontSize.s16)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.colors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
