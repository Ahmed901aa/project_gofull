import 'dart:async';

class OrderPollingService {
  Timer? _timer;
  bool _isPolling = false;
  bool _inFlight = false;

  bool get isPolling => _isPolling;

  void start({
    Duration interval = const Duration(seconds: 3),
    required Future<void> Function() callback,
  }) {
    stop();
    _isPolling = true;
   
    Future<void> tick() async {
      if (_inFlight || !_isPolling) return;
      _inFlight = true;
      try {
        await callback();
      } catch (_) {
        // Swallow — the next tick retries.
      } finally {
        _inFlight = false;
      }
    }

    // Call immediately first, then periodically
    tick();
    _timer = Timer.periodic(interval, (_) => tick());
  }

  void stop() {
    _isPolling = false;
    _timer?.cancel();
    _timer = null;
  }

  void dispose() => stop();
}
