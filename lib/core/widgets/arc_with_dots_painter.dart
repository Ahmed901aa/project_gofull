import 'dart:math';
import 'package:flutter/material.dart';

class ArcWithDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // Gradient arc fading from transparent to white
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: pi * 0.75,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.7),
          Colors.white.withValues(alpha: 0.9),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(arcRect);

    canvas.drawArc(arcRect, -pi / 2, pi * 1.5, false, arcPaint);

    // Leading dot (bright, at end of arc)
    final leadingAngle = -pi / 2 + pi * 1.5;
    canvas.drawCircle(
      Offset(center.dx + radius * cos(leadingAngle), center.dy + radius * sin(leadingAngle)),
      3.5,
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );

    // Trailing dot (faded, at start of arc)
    canvas.drawCircle(
      Offset(center.dx + radius * cos(-pi / 2), center.dy + radius * sin(-pi / 2)),
      2.5,
      Paint()..color = Colors.white.withValues(alpha: 0.3),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
