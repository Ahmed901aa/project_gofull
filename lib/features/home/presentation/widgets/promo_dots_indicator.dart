import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';

class PromoDotsIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const PromoDotsIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (i) {
        final isActive = i == currentPage;
        return Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 2.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 8.w : 5.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.primary200,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      }),
    );
  }
}
