import 'dart:math';
import 'package:flutter/material.dart';

/// Green gradient circle with evenly-spaced white dots around the edge
/// and an optional center icon.
///
/// Usage:
/// ```dart
/// DottedCircleContainer(
///   icon: Icon(Icons.fire_truck, color: Colors.white, size: 40),
/// )
/// ```
class DottedCircleContainer extends StatelessWidget {
  final Widget? icon;
  final double size;
  final int dotCount;
  final double dotRadius;

  const DottedCircleContainer({
    super.key,
    this.icon,
    this.size = 108,
    this.dotCount = 24,
    this.dotRadius = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Green gradient circle
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF004B3B), Color(0xFF8AACA5)],
              ),
            ),
          ),

          // White dots around the circumference
          CustomPaint(
            size: Size(size, size),
            painter: _DottedBorderPainter(
              dotCount: dotCount,
              dotRadius: dotRadius,
            ),
          ),

          if (icon != null) icon!,
        ],
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final int dotCount;
  final double dotRadius;

  const _DottedBorderPainter({
    required this.dotCount,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - dotRadius;
    final paint = Paint()
      ..color = const Color(0xFFB0C7C2)
      ..style = PaintingStyle.fill;

    // Rectangle dimensions: 6px tangential length, 4px radial width
    const rectW = 3.0;
    const rectH = 6.0;
    final rect = Rect.fromCenter(center: Offset.zero, width: rectW, height: rectH);

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * pi * i) / dotCount;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle); // align rectangle tangentially
      canvas.drawRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
