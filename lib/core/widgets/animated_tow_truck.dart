import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

/// The app's tow-truck icon travelling along the trip route.
///
/// Renders the EXISTING [TowTruckIcon] artwork unchanged — same asset,
/// same shape, same colours — and only animates its position, so the
/// vehicle reads as driving from the pickup point toward the destination.
///
/// Direction is locale-correct for free: the truck is positioned with
/// [AlignmentDirectional], so it travels left→right in English and
/// right→left in Arabic, and [TowTruckIcon] already mirrors its artwork to
/// face the direction of travel.
///
/// Motion design: one continuous forward pass with eased acceleration and
/// deceleration (no shake, bounce, spin, or reversing). The truck fades in
/// as it enters and out as it leaves, so the loop restart is invisible
/// rather than a visible snap back.
///
/// Set [moving] to false for stationary statuses (arrived / completed):
/// the ticker is stopped entirely — it costs nothing while parked — and
/// the truck rests at the start of the route.
///
/// Honours the OS "reduce motion" accessibility setting by holding the
/// truck static.
class AnimatedTowTruck extends StatefulWidget {
  /// Whether the vehicle is currently in motion.
  final bool moving;

  /// Diameter of the truck glyph.
  final double truckSize;

  /// Height of the whole route lane.
  final double height;

  /// One full traversal of the route.
  final Duration duration;

  const AnimatedTowTruck({
    super.key,
    required this.moving,
    this.truckSize = 56,
    this.height = 96,
    this.duration = const Duration(milliseconds: 3200),
  });

  @override
  State<AnimatedTowTruck> createState() => _AnimatedTowTruckState();
}

class _AnimatedTowTruckState extends State<AnimatedTowTruck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);

  /// Eased travel so the vehicle accelerates away and settles on approach
  /// instead of sliding at a constant, mechanical rate.
  late final Animation<double> _travel =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);

  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accessibility: respect the OS reduce-motion switch.
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce != _reduceMotion) {
      _reduceMotion = reduce;
      _sync();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedTowTruck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moving != widget.moving) _sync();
  }

  /// Start or stop the ticker to match the current status. Stopping (rather
  /// than animating a still frame) keeps a parked order off the vsync
  /// callback list entirely.
  void _sync() {
    if (widget.moving && !_reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Fade envelope that hides the loop restart: in over the first slice,
  /// solid through the middle, out over the last slice.
  double _opacityAt(double t) {
    const fadeIn = 0.10;
    const fadeOut = 0.88;
    if (t < fadeIn) return t / fadeIn;
    if (t > fadeOut) return (1 - t) / (1 - fadeOut);
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _travel,
        builder: (context, _) {
          final t = widget.moving && !_reduceMotion ? _travel.value : 0.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Route: full track, plus the portion already covered.
              Positioned.fill(
                child: CustomPaint(
                  painter: _RoutePainter(
                    progress: t,
                    isRtl: Directionality.of(context) == TextDirection.rtl,
                    trackColor: colors.border,
                    coveredColor: colors.primary,
                  ),
                ),
              ),
              // Origin marker (start of the route).
              AlignmentDirectionalDot(
                alignment: const AlignmentDirectional(-1, 0.28),
                child: _OriginDot(color: colors.primary),
              ),
              // Destination marker (end of the route).
              AlignmentDirectionalDot(
                alignment: const AlignmentDirectional(1, 0.28),
                child: Icon(Icons.place_rounded,
                    size: 20.sp, color: colors.primary),
              ),
              // The vehicle itself — unchanged artwork, moved along the lane.
              Align(
                // -1 = route start, 1 = route end, resolved per text
                // direction, so RTL travels right→left automatically.
                alignment: AlignmentDirectional(-1 + 2 * t, -0.25),
                child: Opacity(
                  // The fade envelope exists only to hide the loop
                  // restart. A parked vehicle sits at t = 0, where the
                  // envelope would be fully transparent — it must stay
                  // solid so an 'arrived' order still shows its truck.
                  opacity: widget.moving && !_reduceMotion
                      ? _opacityAt(t)
                      : 1.0,
                  child: TowTruckIcon(size: widget.truckSize),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Small helper so markers read clearly at the call site.
class AlignmentDirectionalDot extends StatelessWidget {
  final AlignmentDirectional alignment;
  final Widget child;
  const AlignmentDirectionalDot({
    super.key,
    required this.alignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) =>
      Align(alignment: alignment, child: child);
}

class _OriginDot extends StatelessWidget {
  final Color color;
  const _OriginDot({required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.surface,
          border: Border.all(color: color, width: 3),
        ),
      );
}

/// Dashed route line with a solid "already travelled" section behind the
/// vehicle. Repaints only when the progress value changes.
class _RoutePainter extends CustomPainter {
  final double progress;
  final bool isRtl;
  final Color trackColor;
  final Color coveredColor;

  const _RoutePainter({
    required this.progress,
    required this.isRtl,
    required this.trackColor,
    required this.coveredColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * 0.64;
    const inset = 14.0;
    final left = inset;
    final right = size.width - inset;

    final track = Paint()
      ..color = trackColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final covered = Paint()
      ..color = coveredColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Dashed full route.
    const dash = 7.0;
    const gap = 6.0;
    for (double x = left; x < right; x += dash + gap) {
      final end = (x + dash).clamp(left, right);
      canvas.drawLine(Offset(x, y), Offset(end, y), track);
    }

    // Solid covered portion, growing from the route's start edge.
    if (progress > 0) {
      final span = (right - left) * progress;
      if (isRtl) {
        canvas.drawLine(Offset(right, y), Offset(right - span, y), covered);
      } else {
        canvas.drawLine(Offset(left, y), Offset(left + span, y), covered);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) =>
      old.progress != progress ||
      old.isRtl != isRtl ||
      old.trackColor != trackColor ||
      old.coveredColor != coveredColor;
}
