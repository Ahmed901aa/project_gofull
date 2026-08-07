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

/// Drop-in [Icon] wrapper used wherever a service icon is rendered.
///
/// Vehicle icons (tow truck, shipping) are intentionally NOT mirrored in
/// RTL: they are non-directional artwork, and mirroring them makes the
/// artwork look wrong in Arabic. Directional icons (arrows, chevrons)
/// mirror automatically via their built-in [IconData.matchTextDirection].
class DirectionalServiceIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  const DirectionalServiceIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) => Icon(icon, size: size, color: color);
}
