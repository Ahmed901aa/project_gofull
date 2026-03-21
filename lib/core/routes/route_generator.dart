import 'package:flutter/material.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/auth/presentation/screens/splash_screen.dart';
import 'package:project_gofull/features/auth/presentation/screens/login_screen.dart';
import 'package:project_gofull/features/auth/presentation/screens/otp_screen.dart';
import 'package:project_gofull/features/fuel/presentation/screens/fuel_screen.dart';
import 'package:project_gofull/features/location/presentation/screens/location_search_screen.dart';
import 'package:project_gofull/features/location/presentation/screens/map_selection_screen.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashScreen(), settings);
      case Routes.login:
        return _buildRoute(const LoginScreen(), settings);
      case Routes.otp:
        final args = settings.arguments as OtpArgs;
        return _buildRoute(OtpScreen(args: args), settings);
      case Routes.home:
        return _buildRoute(const BottomNavShell(), settings);
      case Routes.fuelType:
        return _buildRoute(const FuelScreen(), settings);
      case Routes.locationSearch:
        final args = settings.arguments as LocationSearchArgs;
        return _buildRoute(LocationSearchScreen(args: args), settings);
      case Routes.mapSelection:
        final args = settings.arguments as MapSelectionArgs;
        return _buildRoute(MapSelectionScreen(args: args), settings);
      default:
        return _undefinedRoute();
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => page, settings: settings);

  static Route<dynamic> _undefinedRoute() => MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('الصفحة غير موجودة')),
        ),
      );
}
