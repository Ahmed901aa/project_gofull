import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// The app's tow-truck glyph: custom SVG line art (a truck actually towing
/// a car — the Material "fire_truck"/"local_shipping" glyphs read as a fire
/// engine / box van and were replaced by design request, 2026-08).
///
/// The artwork faces RIGHT (the LTR travel direction). In Arabic (RTL) it
/// is mirrored so the truck faces the reading/travel direction. Pass
/// [autoMirror] false when an ancestor already applies the RTL flip.
class TowTruckIcon extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool autoMirror;
  const TowTruckIcon({super.key, this.size, this.color, this.autoMirror = true});

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      'assets/svg/tow_truck.svg',
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
    if (!autoMirror) return svg;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return isRtl ? Transform.flip(flipX: true, child: svg) : svg;
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
