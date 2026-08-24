import 'package:flutter/material.dart';

/// Back-navigation arrow. Points ← in LTR and → in RTL.
///
/// These Material icons already have [IconData.matchTextDirection] set to
/// `true`, so Flutter mirrors them automatically.  We must NOT swap the
/// icon ourselves — doing so causes a double-flip (wrong direction).
IconData backArrowIcon(BuildContext context) => Icons.arrow_back_rounded;

/// Forward / "continue" arrow. Points → in LTR and ← in RTL.
///
/// [matchTextDirection] handles the flip automatically.
IconData forwardArrowIcon(BuildContext context) => Icons.arrow_forward_rounded;

/// Trailing chevron for list rows / menu items. Points > in LTR and < in RTL.
///
/// [matchTextDirection] handles the flip automatically.
IconData forwardChevronIcon(BuildContext context) => Icons.arrow_forward_ios_rounded;

/// The app's tow-truck glyph: raster artwork at
/// `assets/images/icon_truck.png` (a truck actually towing a car — the
/// Material "fire_truck"/"local_shipping" glyphs read as a fire engine /
/// box van and were replaced by design request, 2026-08).
///
/// The artwork faces one direction as authored. In the opposite reading
/// direction (Arabic RTL) it is mirrored so the truck faces the reading /
/// travel direction. Pass [autoMirror] false when an ancestor already
/// applies the RTL flip. [color] tints the artwork; pass null to render
/// the PNG's own colors.
class TowTruckIcon extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool autoMirror;
  const TowTruckIcon({super.key, this.size, this.color, this.autoMirror = true});

  @override
  Widget build(BuildContext context) {
    // Render the PNG in its native colors — call sites may pass a tint
    // color (e.g. white for dark backgrounds), but by design the truck
    // artwork should always look like the source image.
    Widget img = Image.asset(
      'assets/images/icon_truck.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
    if (!autoMirror) return img;
    // The PNG artwork is authored facing LEFT — the RTL / Arabic travel
    // direction. In Arabic we render it as-is; in LTR we mirror it so
    // the truck faces the LTR forward direction.
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return isRtl ? img : Transform.flip(flipX: true, child: img);
  }
}

/// Renders a glyph that Flutter will **not** mirror on its own — i.e. one
/// whose [IconData.matchTextDirection] is `false`, such as the play/
/// keyboard-arrow families — and flips it horizontally in RTL so
/// forward-motion cues always point the way the user reads.
///
/// Reacts to live locale changes for free: [Directionality.of] is an
/// inherited lookup, so switching Arabic ⇄ English rebuilds this widget
/// with the new direction.
///
/// Only for glyphs that genuinely encode reading direction. Do NOT use it
/// for vertically-symmetric glyphs (`Icons.navigation_rounded` points up —
/// mirroring is a no-op), for true media-transport controls (Material's
/// RTL guidance keeps play/fast-forward pointing right), or for icons that
/// already mirror themselves (that would double-flip them back).
class MirroredIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  const MirroredIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(icon, size: size, color: color);
    return Directionality.of(context) == TextDirection.rtl
        ? Transform.flip(flipX: true, child: glyph)
        : glyph;
  }
}

/// Drop-in [Icon] wrapper used wherever a service icon is rendered.
///
/// Non-directional artwork (gas pump, etc.) is rendered as-is in both
/// directions. Truck glyphs are special-cased centrally here: every call
/// site that used to pass a Material truck icon now renders the custom
/// [TowTruckIcon] (which also mirrors itself in RTL) — one swap point, no
/// per-site churn. Directional icons (arrows, chevrons) mirror
/// automatically via their built-in [IconData.matchTextDirection].
class DirectionalServiceIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  const DirectionalServiceIcon(this.icon, {super.key, this.size, this.color});

  // NOTE: not const — IconData overrides ==, which const sets forbid.
  static final _truckGlyphs = <IconData>{
    Icons.fire_truck,
    Icons.fire_truck_rounded,
    Icons.fire_truck_outlined,
    Icons.local_shipping,
    Icons.local_shipping_rounded,
    Icons.local_shipping_outlined,
    Icons.car_crash_rounded,
  };

  @override
  Widget build(BuildContext context) {
    if (_truckGlyphs.contains(icon)) {
      return TowTruckIcon(size: size, color: color);
    }
    return Icon(icon, size: size, color: color);
  }
}
