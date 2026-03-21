class ApiConstants {
  const ApiConstants._();

  // Base URL — update when backend is ready
  static const String baseUrl = 'https://api.gofull.app/api/v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';

  // Service endpoints
  static const String offers = '/offers';
  static const String fuelTypes = '/fuel/types';
  static const String fuelOrders = '/fuel/orders';
  static const String towingRequests = '/towing/requests';
  static const String orders = '/orders';
  static const String profile = '/profile';
}
