import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case OrderStatus.active:
        bgColor = const Color(0xFFF2F3F4);
        textColor = const Color(0xFF0E0E0E);
        label = S.of(context).inProgressLabel;
      case OrderStatus.cancelled:
        bgColor = const Color(0xFFFDECEA);
        textColor = const Color(0xFFD32F2F);
        label = S.of(context).cancelledLabel;
      case OrderStatus.completed:
        bgColor = const Color(0xFFF2F3F4);
        textColor = const Color(0xFF646565);
        label = S.of(context).completedLabel;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppRadius.s16)),
      child: Text(label, style: getMediumStyle(color: textColor, fontSize: FontSize.s12)),
    );
  }
}
