import 'package:flutter/foundation.dart';

final Stopwatch _startupWatch = Stopwatch()..start();


void logStartup(String message) {
  debugPrint('[STARTUP +${_startupWatch.elapsedMilliseconds}ms] $message');
}
