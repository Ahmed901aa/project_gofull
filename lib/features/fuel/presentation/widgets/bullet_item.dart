import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';

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
        textDirection: TextDirection.rtl,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 6.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
