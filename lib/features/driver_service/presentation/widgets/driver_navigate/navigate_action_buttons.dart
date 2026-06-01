import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';

class NavigateActionButtons extends StatelessWidget {
  final bool isToCustomer;
  final bool isFuel;
  final String? customerPhone;
  final VoidCallback onOpenMaps;
  final VoidCallback onArrived;
  final VoidCallback onCancel;

  const NavigateActionButtons({
    super.key,
    required this.isToCustomer,
    required this.isFuel,
    required this.customerPhone,
    required this.onOpenMaps,
    required this.onArrived,
    required this.onCancel,
  });

  void _call() {
    final phone = customerPhone;
    if (phone != null && phone.isNotEmpty) launchUrl(Uri.parse('tel:$phone'));
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                    text: S.of(context).openInGoogleMaps, isOutlined: true, onPressed: onOpenMaps),
              ),
              SizedBox(width: Insets.s8),
              GestureDetector(
                onTap: _call,
                child: Container(
                  width: Sizes.s48,
                  height: Sizes.s48,
                  decoration: BoxDecoration(
                    color: context.colors.primarySurface,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  child: Icon(Icons.phone_rounded, size: 22.sp, color: context.colors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s12),
          AppButton(
            text: isToCustomer && isFuel
                ? S.of(context).arrivedStartRefueling
                : S.of(context).arrivedStartDoc,
            onPressed: onArrived,
          ),
          SizedBox(height: Insets.s8),
          GestureDetector(
            onTap: onCancel,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              alignment: Alignment.center,
              child: Text(
                S.of(context).cancelOrderLabel,
                style: getMediumStyle(color: context.colors.error, fontSize: FontSize.s14),
              ),
            ),
          ),
        ],
      );
}
