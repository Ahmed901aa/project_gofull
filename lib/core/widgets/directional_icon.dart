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
