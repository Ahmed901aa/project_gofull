import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  static final NotiService _instance = NotiService._internal();
  factory NotiService() => _instance;
  NotiService._internal();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // ── Initialize ─────────────────────────────────────────────

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create Android notification channel
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'gofull_orders',
            'إشعارات الطلبات',
            description: 'إشعارات حالة طلبات الوقود والسحب',
            importance: Importance.high,
            playSound: true,
          ),
        );

    _isInitialized = true;
  }

  // ── Show notification ──────────────────────────────────────

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initNotification();

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'gofull_orders',
          'إشعارات الطلبات',
          channelDescription: 'إشعارات حالة طلبات الوقود والسحب',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
