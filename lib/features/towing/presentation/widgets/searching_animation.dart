import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchingAnimation extends StatelessWidget {
  const SearchingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        Container(
          width: 108.w,
          height: 108.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF004B3B).withValues(alpha: 0.1),
                const Color(0xFF8AACA5).withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
        // Inner solid gradient circle
        Container(
          width: 96.w,
          height: 96.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF004B3B), Color(0xFF8AACA5)],
            ),
          ),
        ),
        // Spinning arc
        SizedBox(
          width: 40.w,
          height: 40.w,
          child: CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }
}
