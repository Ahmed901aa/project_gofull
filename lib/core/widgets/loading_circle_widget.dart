import 'dart:math';
import 'package:flutter/material.dart';
import 'arc_with_dots_painter.dart';

/// Reusable loading circle widget matching the Figma design.
/// Green gradient circle with a spinning arc that has dots at both tips.
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
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: ArcWithDotsPainter(),
              ),
            ),
          ),
          if (widget.icon != null) widget.icon!,
        ],
      ),
    );
  }
}
