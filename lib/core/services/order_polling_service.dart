import 'dart:async';

/// Reusable polling utility — calls [callback] every [interval] until stopped.
class OrderPollingService {
  Timer? _timer;
  bool _isPolling = false;

  bool get isPolling => _isPolling;

  void start({
    Duration interval = const Duration(seconds: 3),
    required Future<void> Function() callback,
  }) {
    stop();
    _isPolling = true;
    // Call immediately first, then periodically
    callback();
    _timer = Timer.periodic(interval, (_) {
      if (_isPolling) callback();
    });
  }

  void stop() {
    _isPolling = false;
    _timer?.cancel();
    _timer = null;
  }

  void dispose() => stop();
}
