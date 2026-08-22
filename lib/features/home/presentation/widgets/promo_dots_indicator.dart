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
          padding: EdgeInsetsDirectional.symmetric(horizontal: 3.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            width: isActive ? 22.w : 7.w,
            height: 7.h,
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                      colors: [
                        activeColor,
                        activeColor.withValues(alpha: 0.75),
                      ],
                    )
                  : null,
              color: isActive ? null : activeColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
