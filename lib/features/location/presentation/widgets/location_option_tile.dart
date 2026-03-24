import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';

class CurrentLocationTile extends StatelessWidget {
  const CurrentLocationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, AppStrings.yourCurrentLocation),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
        child: Row(
          children: [
            Container(
              width: 26.w,
              height: 26.w,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: Icon(Icons.my_location_rounded, color: AppColors.white, size: 14.sp),
            ),
            SizedBox(width: Insets.s12),
            Text(
              AppStrings.yourCurrentLocation,
              style: getMediumStyle(color: AppColors.primary, fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseOnMapTile extends StatelessWidget {
  final String title;
  const ChooseOnMapTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.mapSelection,
        arguments: MapSelectionArgs(title: title),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: AppColors.primary, size: 24.sp),
            SizedBox(width: Insets.s12),
            Text(
              'حدد الموقع علي الخريطة',
              style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }
}
