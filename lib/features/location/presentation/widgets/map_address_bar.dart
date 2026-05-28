import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class MapAddressBar extends StatelessWidget {
  final String address;
  final VoidCallback? onSearchTap;

  const MapAddressBar({super.key, required this.address, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      padding: EdgeInsets.fromLTRB(Insets.s16, 0, Insets.s16, Insets.s12),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: Insets.s12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: context.colors.inputBorder),
          boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: GestureDetector(
          onTap: onSearchTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: context.colors.iconSecondary, size: 20.sp),
              SizedBox(width: Insets.s8),
              Expanded(
                child: Text(
                  address.isEmpty ? S.of(context).searchForLocationDots : address,
                  style: getMediumStyle(
                    color: address.isEmpty ? context.colors.iconSecondary : context.colors.textPrimary,
                    fontSize: FontSize.s12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: Insets.s8),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: context.colors.iconSecondary, size: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
