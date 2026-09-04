import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';

/// The customer shell's floating bottom navigation.
///
/// The bar is a pill that hovers above the bottom edge with a margin on all
/// sides and a soft shadow, so it reads as a surface layered over the page
/// rather than a strip welded to the frame:
///  * one rounded capsule, inset from the screen edges and lifted off the
///    bottom (above the system gesture inset),
///  * a green selection pill that SLIDES between tabs instead of appearing,
///  * the selected glyph crossfades to the brand green and fills in; the
///    others stay a subtle grey,
///  * the profile tab is the user's round avatar, ringed green when selected.
///
/// The glyphs are the app's own icons, drawn with [CustomPainter] so their
/// stroke weight matches across the set instead of borrowing Material's
/// heavier icon font. Selection is animated through [_GlyphPainter.progress]
/// (0 → 1) so stroke weight and fill interpolate rather than snap.
///
/// Layout is direction-agnostic: the tabs sit in a plain [Row] and the
/// selection pill is positioned with [AlignmentDirectional], so both resolve
/// start-to-end and the bar mirrors itself correctly in Arabic RTL.

// ───────────────────────── glyphs ─────────────────────────

enum InstaGlyph { home, orders, support }

/// One line-icon, 24-unit design grid scaled to [size].
///
/// [active] is the logical selection state. [progress] is how far the
/// selection animation has travelled (0 = idle, 1 = fully selected); it
/// defaults to the resolved [active] value so the icon can still be used
/// statically.
class InstaGlyphIcon extends StatelessWidget {
  final InstaGlyph glyph;
  final bool active;
  final Color ink;
  final Color background;
  final double size;
  final double? progress;

  const InstaGlyphIcon({
    super.key,
    required this.glyph,
    required this.active,
    required this.ink,
    required this.background,
    this.size = InstaNavBar.iconSize,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GlyphPainter(
        glyph: glyph,
        progress: progress ?? (active ? 1.0 : 0.0),
        ink: ink,
        background: background,
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  final InstaGlyph glyph;

  /// 0 = idle outline, 1 = selected (bolder stroke, filled interior).
  final double progress;
  final Color ink;
  final Color background;

  const _GlyphPainter({
    required this.glyph,
    required this.progress,
    required this.ink,
    required this.background,
  });

  // ~1.7px stroke at 24px when idle, thickening as the tab is selected.
  static const double _strokeIdle = 1.7;
  static const double _strokeActive = 2.4;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.scale(s, s);

    final p = progress.clamp(0.0, 1.0);

    final stroke = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeIdle + (_strokeActive - _strokeIdle) * p
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Interior fill fades in with the selection; the cutouts that carve the
    // door / receipt lines back out fade in alongside it, so the two stay in
    // step and the icon crossfades instead of popping.
    final fill = Paint()
      ..color = ink.withValues(alpha: p)
      ..style = PaintingStyle.fill;
    final cutout = Paint()
      ..color = background.withValues(alpha: p)
      ..style = PaintingStyle.fill;

    switch (glyph) {
      case InstaGlyph.home:
        _home(canvas, stroke, fill, cutout, p);
      case InstaGlyph.orders:
        _orders(canvas, stroke, fill, cutout, p);
      case InstaGlyph.support:
        _support(canvas, stroke, fill, cutout, p);
    }
  }

  /// House: pitched roof, straight walls, a door cut into the bottom edge.
  void _home(Canvas c, Paint stroke, Paint fill, Paint cutout, double p) {
    final house = Path()
      ..moveTo(3.5, 10.5)
      ..lineTo(12, 3.5)
      ..lineTo(20.5, 10.5)
      ..lineTo(20.5, 20.5)
      ..lineTo(3.5, 20.5)
      ..close();
    final door = Path()
      ..addRRect(RRect.fromRectAndRadius(
          const Rect.fromLTWH(9.5, 13.5, 5, 7), const Radius.circular(1)));

    c.drawPath(house, fill);
    c.drawPath(house, stroke);
    c.drawPath(door, cutout);
    if (p < 1) {
      c.drawPath(
        door,
        Paint()
          ..color = ink.withValues(alpha: 1 - p)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  /// Orders: a receipt sheet with three lines of text.
  void _orders(Canvas c, Paint stroke, Paint fill, Paint cutout, double p) {
    final sheet = RRect.fromRectAndRadius(
        const Rect.fromLTWH(5, 3.5, 14, 17), const Radius.circular(2.5));
    const lines = [
      Offset(8.5, 8.5),
      Offset(8.5, 12),
      Offset(8.5, 15.5),
    ];
    const lineEnds = [15.5, 15.5, 12.5];

    c.drawRRect(sheet, fill);
    c.drawRRect(sheet, stroke);

    // The lines read as ink on an empty sheet when idle and as knocked-out
    // gaps once the sheet fills, so both are drawn and crossfaded.
    void drawLines(Color color) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 1.7
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < 3; i++) {
        c.drawLine(lines[i], Offset(lineEnds[i], lines[i].dy), paint);
      }
    }

    if (p < 1) drawLines(ink.withValues(alpha: 1 - p));
    if (p > 0) drawLines(background.withValues(alpha: p));
  }

  /// Support: headset — a head-band arc with two ear cups (symmetric, so it
  /// needs no mirroring in RTL).
  void _support(Canvas c, Paint stroke, Paint fill, Paint cutout, double p) {
    final band = Path()
      ..moveTo(4.5, 14)
      ..lineTo(4.5, 12)
      ..arcToPoint(const Offset(19.5, 12),
          radius: const Radius.circular(7.5), clockwise: true)
      ..lineTo(19.5, 14);
    final leftCup = RRect.fromRectAndRadius(
        const Rect.fromLTWH(3.5, 13, 4.5, 7), const Radius.circular(2));
    final rightCup = RRect.fromRectAndRadius(
        const Rect.fromLTWH(16, 13, 4.5, 7), const Radius.circular(2));

    c.drawPath(band, stroke);
    c.drawRRect(leftCup, fill);
    c.drawRRect(rightCup, fill);
    c.drawRRect(leftCup, stroke);
    c.drawRRect(rightCup, stroke);
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.glyph != glyph ||
      old.progress != progress ||
      old.ink != ink ||
      old.background != background;
}

// ───────────────────────── avatar tab ─────────────────────────

/// The profile tab: the user's photo (or initial) in a circle, ringed in the
/// brand green when selected.
class InstaAvatarIcon extends StatelessWidget {
  final String? imageUrl;
  final String initial;
  final bool active;
  final Color ink;
  final Color background;
  final double size;
  final double? progress;

  const InstaAvatarIcon({
    super.key,
    required this.imageUrl,
    required this.initial,
    required this.active,
    required this.ink,
    required this.background,
    this.size = InstaNavBar.iconSize,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final p = (progress ?? (active ? 1.0 : 0.0)).clamp(0.0, 1.0);
    final url = imageUrl;
    final avatar = ClipOval(
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _initialBubble(colors),
              placeholder: (_, __) => _initialBubble(colors),
            )
          : _initialBubble(colors),
    );

    // The selection ring sits just outside the photo with a hairline of
    // background between them, and fades in with the rest of the selection.
    return Container(
      width: size + 6,
      height: size + 6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ink.withValues(alpha: p),
          width: 1.8,
        ),
      ),
      child: SizedBox(width: size, height: size, child: avatar),
    );
  }

  Widget _initialBubble(AppThemeColors colors) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: colors.primary,
      child: Text(
        initial,
        style: getBoldStyle(color: colors.onPrimary, fontSize: size * 0.5)
            .copyWith(height: 1),
      ),
    );
  }
}

// ───────────────────────── destinations ─────────────────────────

/// A tab of [InstaNavBar]: either a line glyph or the user's avatar, plus an
/// accessibility label (never rendered).
class InstaNavDestination {
  final InstaGlyph? glyph;
  final String? avatarUrl;
  final String avatarInitial;
  final String label;

  const InstaNavDestination.glyph(this.glyph, {required this.label})
      : avatarUrl = null,
        avatarInitial = '';

  const InstaNavDestination.avatar({
    required this.label,
    this.avatarUrl,
    this.avatarInitial = '',
  }) : glyph = null;

  bool get isAvatar => glyph == null;
}

/// One tab: icon only, full-height tap target, slight scale-down while
/// pressed, and a colour/weight crossfade as selection moves in or out.
class NavItem extends StatefulWidget {
  final InstaNavDestination destination;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double iconSize;

  const NavItem({
    super.key,
    required this.destination,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.iconSize = InstaNavBar.iconSize,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    final isActive = widget.currentIndex == widget.index;
    final idleInk = InstaNavBar.idleInkColor(context);
    final activeInk = InstaNavBar.activeInkColor(context);
    // Behind a selected icon sits the green selection pill, not the bar —
    // the knocked-out details have to be carved in THAT colour to disappear.
    final bg = isActive
        ? InstaNavBar.indicatorColor(context)
        : InstaNavBar.barColor(context);

    // The tab is one accessible button named by its label; the glyph or the
    // avatar's initial letter underneath is decorative and must not be read.
    return Semantics(
      container: true,
      excludeSemantics: true,
      button: true,
      selected: isActive,
      label: d.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: () => widget.onTap(widget.index),
        child: SizedBox.expand(
          child: Center(
            child: AnimatedScale(
              scale: _pressed ? 0.86 : 1.0,
              duration: const Duration(milliseconds: 110),
              curve: Curves.easeOut,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: isActive ? 1.0 : 0.0),
                duration: InstaNavBar.transition,
                curve: Curves.easeOutCubic,
                builder: (context, p, _) {
                  final ink = Color.lerp(idleInk, activeInk, p)!;
                  return d.isAvatar
                      ? InstaAvatarIcon(
                          imageUrl: d.avatarUrl,
                          initial: d.avatarInitial,
                          active: isActive,
                          progress: p,
                          ink: ink,
                          background: bg,
                          size: widget.iconSize,
                        )
                      : InstaGlyphIcon(
                          glyph: d.glyph!,
                          active: isActive,
                          progress: p,
                          ink: ink,
                          background: bg,
                          size: widget.iconSize,
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── the bar ─────────────────────────

class InstaNavBar extends StatelessWidget {
  /// Height of the capsule itself, before the floating margins are added.
  static const double barHeight = 64;
  static const double iconSize = 26;

  /// How long the selection pill takes to slide, and the icons to recolour.
  static const Duration transition = Duration(milliseconds: 280);

  static Color barColor(BuildContext context) => context.colors.surface;

  /// The sliding pill behind the selected tab — a green-tinted surface, kept
  /// opaque so the glyphs' knocked-out details land on a known colour.
  static Color indicatorColor(BuildContext context) =>
      context.colors.primarySurface;

  /// Unselected glyphs: the theme's secondary icon grey.
  static Color idleInkColor(BuildContext context) =>
      context.colors.iconSecondary;

  /// Selected glyph: the brand green.
  static Color activeInkColor(BuildContext context) => context.colors.primary;

  /// Retained for callers that used the single pre-selection ink colour.
  static Color inkColor(BuildContext context) => idleInkColor(context);

  /// Horizontal inset from the screen edges. Grows a little with the screen
  /// but stays within a range that keeps the tabs comfortably tappable on a
  /// small phone and stops the bar sprawling on a tablet.
  static double sideInset(double screenWidth) =>
      (screenWidth * 0.045).clamp(12.0, 28.0);

  /// Capsule height, nudged down on very small phones and up on tablets.
  static double resolveHeight(double screenWidth) {
    if (screenWidth < 340) return 56;
    if (screenWidth > 600) return 70;
    return barHeight;
  }

  static double _resolveIconSize(double screenWidth) {
    if (screenWidth < 340) return 23;
    if (screenWidth > 600) return 28;
    return iconSize;
  }

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<InstaNavDestination> items;

  const InstaNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.isDarkMode;
    final width = MediaQuery.sizeOf(context).width;

    final side = sideInset(width);
    final height = resolveHeight(width);
    final icon = _resolveIconSize(width);
    final radius = BorderRadius.circular(height / 2);

    final count = items.length;
    // Alignment slides the child across the space the child does NOT fill,
    // so with a cell-width pill the travel is (count - 1) cells, not count:
    // i = 0 pins it to the start edge and i = count - 1 to the end edge.
    // AlignmentDirectional resolves -1 to the *start* edge, so this tracks
    // the Row's own order in both LTR and RTL.
    final indicatorX =
        count <= 1 ? 0.0 : (2 * currentIndex / (count - 1)) - 1;

    return SafeArea(
      top: false,
      child: Padding(
        // Bottom gap lifts the capsule clear of the gesture bar / screen edge.
        padding: EdgeInsets.fromLTRB(side, 0, side, height * 0.16),
        child: SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: barColor(context),
              borderRadius: radius,
              // A hairline keeps the capsule's edge crisp where the shadow is
              // weakest — on a white page in light mode, on dark in dark mode.
              border: Border.all(
                color: isDark
                    ? colors.borderSubtle
                    : colors.border.withValues(alpha: 0.9),
                width: 0.5,
              ),
              boxShadow: isDark
                  ? [
                      // The dark theme carries no shadow token, but the
                      // capsule still has to lift off the page.
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [
                      // Two shadows: a tight contact shadow plus a wide soft
                      // one, which reads as height rather than as a blur.
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.10),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.13),
                        blurRadius: 22,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  // The selection pill, sliding between cells.
                  AnimatedAlign(
                    alignment: AlignmentDirectional(indicatorX, 0),
                    duration: transition,
                    curve: Curves.easeOutCubic,
                    child: FractionallySizedBox(
                      widthFactor: 1 / count,
                      heightFactor: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: height * 0.09,
                          vertical: height * 0.11,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: indicatorColor(context),
                            borderRadius: BorderRadius.circular(height / 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < count; i++)
                        Expanded(
                          child: NavItem(
                            destination: items[i],
                            index: i,
                            currentIndex: currentIndex,
                            onTap: onTap,
                            iconSize: icon,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
