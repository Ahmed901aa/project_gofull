import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class BulletItem extends StatelessWidget {
  final String text;
  final bool last;
  const BulletItem({super.key, required this.text, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 6.h, start: 6.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.colors.primary),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: getRegularStyle(color: context.colors.primary, fontSize: FontSize.s14),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
