import 'dart:math';
import 'package:flutter/material.dart';



class DottedCircleContainer extends StatelessWidget {
  final String? imagePath;
  final bool loading;
  final double size;
  final int dotCount;
  final double dotRadius;

  const DottedCircleContainer({
    super.key,
    this.imagePath,
    this.loading = false,
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
          // Solid green circle
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF004B3B),
            ),
          ),

          // Rectangular marks around the circumference
          CustomPaint(
            size: Size(size, size),
            painter: _DottedBorderPainter(
              dotCount: dotCount,
              dotRadius: dotRadius,
            ),
          ),

          // Center: loading spinner or GIF image
          if (loading)
            SizedBox(
              width: size * 0.38,
              height: size * 0.38,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          else if (imagePath != null)
            Padding(
              padding: EdgeInsets.all(size * 0.18),
              child: Image.asset(imagePath!, fit: BoxFit.contain),
            ),
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

    const rectW = 3.0;
    const rectH = 6.0;
    final rect = Rect.fromCenter(center: Offset.zero, width: rectW, height: rectH);

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * pi * i) / dotCount;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
