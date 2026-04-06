import 'package:project_gofull/core/network/app_config.dart';

class ApiConstants {
  const ApiConstants._();

  // ── Base ──────────────────────────────────────────────────
  static const String baseUrl = AppConfig.baseUrl;
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ── Auth ──────────────────────────────────────────────────
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String changePassword = '/auth/change-password';

  // ── Driver (Customer) Requests ────────────────────────────
  static const String driverRequests = '/driver/requests';
  static const String driverFuelRequest = '/driver/requests/fuel';
  static const String driverTowingRequest = '/driver/requests/towing';
  static String driverRequestDetails(int id) => '/driver/requests/$id';
  static String driverCancelRequest(int id) => '/driver/requests/$id/cancel';
  static String driverRateProvider(int id) => '/driver/requests/$id/rate';

  // ── Provider ──────────────────────────────────────────────
  static const String providerProfile = '/provider/profile';
  static const String providerAvailability = '/provider/profile/availability';
  static const String providerRequests = '/provider/requests';
  static const String providerHistory = '/provider/requests/history';
  static String providerAcceptRequest(int id) =>
      '/provider/requests/$id/accept';
  static String providerRejectRequest(int id) =>
      '/provider/requests/$id/reject';
  static String providerUpdateStatus(int id) =>
      '/provider/requests/$id/status';
  static String providerRateDriver(int id) => '/provider/requests/$id/rate';
  static const String providerActiveRequest = '/provider/requests/active';

  // ── Home & Content ─────────────────────────────────────────
  static const String home = '/home';
  static const String fuelPrices = '/fuel/prices';
  static const String appSettings = '/app/settings';
  static const String offers = '/home'; // banners come from /home

  // ── Profile ───────────────────────────────────────────────
  static const String profile = '/profile';

  // ── Notifications ─────────────────────────────────────────
  static const String notifications = '/notifications';
}
