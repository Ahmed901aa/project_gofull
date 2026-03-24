import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class LocationSearchAppBar extends StatelessWidget {
  final String title;

  const LocationSearchAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 14.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s18),
            textAlign: TextAlign.center,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle),
                child: Icon(Icons.close, size: 18.sp, color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
