import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// TODO: Remove in production — mock only.
class MockTriggerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const MockTriggerButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 6.h),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.warning,
          side: BorderSide(color: context.colors.warning),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
          minimumSize: Size(double.infinity, 44.h),
        ),
        child: Text(label, style: getBoldStyle(color: context.colors.warning, fontSize: FontSize.s14)),
      ),
    );
  }
}
