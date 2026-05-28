import 'package:flutter/material.dart';

/// Returns [Icons.arrow_forward_rounded] in RTL, [Icons.arrow_back_rounded] in LTR.
/// Use for navigation back buttons that should flip with text direction.
IconData backArrowIcon(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
        ? Icons.arrow_forward_rounded
        : Icons.arrow_back_rounded;

/// Returns [Icons.arrow_back_ios_rounded] in RTL, [Icons.arrow_forward_ios_rounded] in LTR.
/// Use for trailing "chevron" arrows on list items / menu rows.
IconData forwardChevronIcon(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
        ? Icons.arrow_back_ios_rounded
        : Icons.arrow_forward_ios_rounded;
