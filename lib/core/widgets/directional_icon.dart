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

/// Material tow-truck icons do not have `matchTextDirection`, so the cabin
/// always faces the same way regardless of locale. We auto-mirror them in
/// RTL via [RtlMirror].
final Set<IconData> _kTowTruckIcons = {
  Icons.fire_truck,
  Icons.fire_truck_rounded,
  Icons.fire_truck_outlined,
  Icons.local_shipping,
  Icons.local_shipping_rounded,
  Icons.local_shipping_outlined,
};

/// Returns `true` if [icon] is one of the tow-truck icons that needs to be
/// mirrored horizontally in RTL layouts.
bool isTowTruckIcon(IconData icon) => _kTowTruckIcons.contains(icon);

/// Horizontally mirrors [child] when the ambient [Directionality] is RTL.
///
/// Use this to flip directional artwork (the tow-truck icon and the SVG used
/// in service badges) so the vehicle faces the correct way in Arabic.
class RtlMirror extends StatelessWidget {
  final Widget child;
  const RtlMirror({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (Directionality.of(context) != TextDirection.rtl) return child;
    return Transform(
      transform: Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
      alignment: Alignment.center,
      child: child,
    );
  }
}

/// Drop-in replacement for [Icon] that auto-mirrors tow-truck icons in RTL.
/// Non-tow icons render unchanged so this is safe to use anywhere a generic
/// [IconData] is rendered (e.g. dynamic lists / search results).
class DirectionalServiceIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  const DirectionalServiceIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: size, color: color);
    if (!isTowTruckIcon(icon)) return iconWidget;
    return RtlMirror(child: iconWidget);
  }
}
