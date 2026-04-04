class ApiConstants {
  const ApiConstants._();

  // Base URL — change to your local IP for device testing (e.g. 192.168.x.x)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String verifyOtp = '/auth/verify-otp';
  static const String changePassword = '/auth/change-password';

  // Customer (driver) endpoints
  static const String offers = '/offers';
  static const String fuelTypes = '/fuel/types';
  static const String fuelOrders = '/fuel/orders';
  static const String towingRequests = '/towing/requests';
  static const String orders = '/orders';
  static const String profile = '/profile';

  // Provider endpoints (driver app)
  static const String providerProfile = '/provider/profile';
  static const String providerAvailability = '/provider/profile/availability';
  static const String providerRequests = '/provider/requests';
  static const String providerRequestsHistory = '/provider/requests/history';
  static String providerAcceptRequest(int id) => '/provider/requests/$id/accept';
  static String providerRejectRequest(int id) => '/provider/requests/$id/reject';
  static String providerUpdateStatus(int id) => '/provider/requests/$id/status';
  static String providerRateCustomer(int id) => '/provider/requests/$id/rate';
  static String providerRequestDetails(int id) => '/provider/requests/$id';

  // Notifications
  static const String notifications = '/notifications';
}
