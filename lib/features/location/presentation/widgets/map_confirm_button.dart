import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class MapConfirmButton extends StatelessWidget {
  final String address;

  const MapConfirmButton({super.key, required this.address});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s16, Insets.s16, 32.h),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
        boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, address),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s12)),
            elevation: 0,
          ),
          child: Text(S.of(context).confirm, style: getBoldStyle(color: context.colors.onPrimary, fontSize: FontSize.s16)),
        ),
      ),
    );
  }
}
