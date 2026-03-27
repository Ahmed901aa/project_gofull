import 'dart:math';
import 'package:flutter/material.dart';

/// Reusable loading circle widget matching the Figma design.
/// Green gradient circle with a spinning arc that has dots at both tips.
///
/// Usage:
/// ```dart
/// LoadingCircleWidget(
///   icon: Icon(Icons.local_shipping, color: Colors.white, size: 40),
/// )
/// ```
class LoadingCircleWidget extends StatefulWidget {
  final Widget? icon;
  final double size;

  const LoadingCircleWidget({
    super.key,
    this.icon,
    this.size = 108,
  });

  @override
  State<LoadingCircleWidget> createState() => _LoadingCircleWidgetState();
}

class _LoadingCircleWidgetState extends State<LoadingCircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final innerSize = widget.size - 4;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow circle
          Container(
            width: widget.size,
            height: widget.size,
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

          // Inner green gradient circle
          Container(
            width: innerSize,
            height: innerSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF004B3B), Color(0xFF8AACA5)],
              ),
            ),
          ),

          // Spinning arc with dots at tips
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ArcWithDotsPainter(),
              ),
            ),
          ),

          if (widget.icon != null) widget.icon!,
        ],
      ),
    );
  }
}

class _ArcWithDotsPainter extends CustomPainter {
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
