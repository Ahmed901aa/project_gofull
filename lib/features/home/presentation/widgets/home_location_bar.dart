import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';

class HomeLocationBar extends StatelessWidget {
  final String address;

  const HomeLocationBar({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.locationSearch,
        arguments: const LocationSearchArgs(title: 'الموقع الحالي'),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Insets.s16, 0, Insets.s16, Insets.s16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(Insets.s16, 4.h, Insets.s8, Insets.s8),
          decoration: BoxDecoration(
            color: AppColors.neutral200,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.yourCurrentLocation,
                        style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s12)),
                    SizedBox(height: 2.h),
                    Text(address,
                        style: getMediumStyle(
                            color: AppColors.black,
                            fontSize: FontSize.s14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey, size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }
}
