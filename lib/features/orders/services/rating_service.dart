import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static const _prefix = 'rated_order_';

  static Future<bool> isOrderRated(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$orderId') ?? false;
  }

  static Future<void> markOrderRated(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$orderId', true);
  }
}
