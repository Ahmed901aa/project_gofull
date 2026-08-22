import 'package:flutter/foundation.dart';

final Stopwatch _startupWatch = Stopwatch()..start();

/// Timestamped startup breadcrumb.
///
/// Makes "where exactly did startup stop?" a one-glance answer in any
/// console (terminal `flutter run`, IDE Debug Console, DevTools). If the
/// app ever sits on the splash screen, the LAST printed line is the step
/// that never completed — and if NO lines print at all, the isolate was
/// started paused by the debugger and never resumed (an IDE/tooling issue,
/// not app code).
void logStartup(String message) {
  debugPrint('[STARTUP +${_startupWatch.elapsedMilliseconds}ms] $message');
}
