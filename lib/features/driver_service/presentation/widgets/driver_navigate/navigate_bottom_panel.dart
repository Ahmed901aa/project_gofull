import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_location_row.dart';
import 'package:project_gofull/features/driver_service/presentation/widgets/driver_navigate/navigate_action_buttons.dart';

class NavigateBottomPanel extends StatelessWidget {
  final bool isToCustomer;
  final bool isFuel;
  final String address;
  final String remainingDistance;
  final String? customerPhone;
  final VoidCallback onOpenMaps;
  final VoidCallback onArrived;
  final VoidCallback onCancel;

  const NavigateBottomPanel({
    super.key,
    required this.isToCustomer,
    required this.isFuel,
    required this.address,
    required this.remainingDistance,
    required this.customerPhone,
    required this.onOpenMaps,
    required this.onArrived,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
          boxShadow: [
            BoxShadow(color: context.colors.shadow, blurRadius: 16.r, offset: const Offset(0, -4)),
          ],
        ),
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s20, Insets.s16,
            Insets.s16 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: Insets.s16),
            NavigateLocationRow(isToCustomer: isToCustomer, address: address),
            if (remainingDistance.isNotEmpty) ...[
              SizedBox(height: Insets.s12),
              _distanceChip(context),
            ],
            SizedBox(height: Insets.s16),
            NavigateActionButtons(
              isToCustomer: isToCustomer,
              isFuel: isFuel,
              customerPhone: customerPhone,
              onOpenMaps: onOpenMaps,
              onArrived: onArrived,
              onCancel: onCancel,
            ),
          ],
        ),
      );

  Widget _distanceChip(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: Insets.s8),
        decoration: BoxDecoration(
          color: context.colors.primarySurface,
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.straighten_rounded, size: 18.sp, color: context.colors.primary),
            SizedBox(width: 6.w),
            Text('${S.of(context).remainingDistance} $remainingDistance',
                style: getMediumStyle(color: context.colors.primary, fontSize: FontSize.s14)),
          ],
        ),
      );
}
