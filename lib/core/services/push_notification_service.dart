/// Placeholder — push notifications are not enabled.
/// To enable real push notifications when the app is killed,
/// Firebase Cloud Messaging (FCM) must be set up.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  Future<void> init() async {}
  Future<void> registerAfterLogin() async {}
}
