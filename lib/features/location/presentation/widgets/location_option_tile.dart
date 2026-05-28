import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Two quick-action rows separated by a divider.
/// Callbacks are provided by the parent screen.
class LocationOptionTile extends StatelessWidget {
  final VoidCallback onGpsTap;
  final VoidCallback onMapTap;
  const LocationOptionTile(
      {super.key, required this.onGpsTap, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionRow(
          icon: Icon(Icons.my_location_rounded,
              color: context.colors.primary, size: 22.sp),
          label: S.of(context).yourLocation,
          onTap: onGpsTap,
          labelColor: context.colors.textPrimary,
        ),
        Divider(color: context.colors.border, height: 1),
        _ActionRow(
          icon: Icon(Icons.location_on_outlined,
              color: context.colors.primary, size: 22.sp),
          label: S.of(context).selectLocationOnMapAlt,
          onTap: onMapTap,
          labelColor: context.colors.textPrimary,
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;
  const _ActionRow(
      {required this.icon,
      required this.label,
      required this.labelColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          child: Row(
            // MainAxisAlignment.start in RTL = right-aligned content
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // RTL first child → rightmost = icon
              icon,
              SizedBox(width: Insets.s8),
              Text(label,
                  style: getBoldStyle(color: labelColor, fontSize: FontSize.s14)),
            ],
          ),
        ),
      ),
    );
  }
}
