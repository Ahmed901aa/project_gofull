import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoDotsIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Color activeColor;

  const PromoDotsIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
    this.activeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (i) {
        final isActive = i == currentPage;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 16.w : 6.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: isActive ? activeColor : activeColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      }),
    );
  }
}
