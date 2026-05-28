import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class MapTopBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  const MapTopBar({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.w, height: 36.w,
              decoration: BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle),
              child: Icon(Icons.close, size: 18.sp, color: AppColors.black),
            ),
          ),
          Expanded(
            child: Text(
              S.of(context).currentLocation,
              style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s18),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: onSearchTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 36.w, height: 36.w,
              decoration: BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle),
              child: Icon(Icons.search_rounded, size: 18.sp, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
