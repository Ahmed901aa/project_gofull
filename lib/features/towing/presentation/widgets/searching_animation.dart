import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchingAnimation extends StatelessWidget {
  final Animation<double> rotation;
  const SearchingAnimation({super.key, required this.rotation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow circle
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
        // Spinning indicator
        RotationTransition(
          turns: rotation,
          child: SizedBox(
            width: 60.w,
            height: 60.w,
            child: CircularProgressIndicator(
              color: Colors.white.withValues(alpha: 0.7),
              strokeWidth: 3,
            ),
          ),
        ),
      ],
    );
  }
}
