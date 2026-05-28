import 'package:flutter/material.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/auth/presentation/screens/splash_screen.dart';
import 'package:project_gofull/features/auth/presentation/screens/login_screen.dart';
import 'package:project_gofull/features/auth/presentation/screens/register_screen.dart';
import 'package:project_gofull/features/fuel/presentation/screens/fuel_screen.dart';
import 'package:project_gofull/features/fuel/presentation/screens/fuel_complete_screen.dart';
import 'package:project_gofull/features/fuel/presentation/screens/trip_details_screen.dart';
import 'package:project_gofull/features/fuel/presentation/screens/rating_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/driver_arrived_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/towing_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/trip_in_progress_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/searching_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/driver_found_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/service_arrived_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/towing_started_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/camera_screen.dart';
import 'package:project_gofull/features/towing/presentation/screens/towing_trip_details_screen.dart';
import 'package:project_gofull/features/location/presentation/screens/location_search_screen.dart';
import 'package:project_gofull/features/location/presentation/screens/map_selection_screen.dart';
import 'package:project_gofull/features/location/presentation/screens/location_picker_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/discount_codes_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/faq_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/terms_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/support_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/privacy_policy_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/about_screen.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/features/notifications/presentation/screens/notifications_screen.dart';
// Driver App imports
import 'package:project_gofull/features/driver_home/presentation/screens/driver_home_screen.dart';
import 'package:project_gofull/features/driver_profile/presentation/screens/driver_profile_screen.dart';
import 'package:project_gofull/features/driver_profile/presentation/screens/driver_reports_screen.dart';
import 'package:project_gofull/features/driver_orders/presentation/screens/driver_orders_screen.dart';
import 'package:project_gofull/features/driver_orders/presentation/screens/driver_trip_details_screen.dart';
import 'package:project_gofull/features/driver_support/presentation/screens/driver_support_screen.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_order_details_screen.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_navigate_screen.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_documentation_screen.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_refueling_screen.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_collect_payment_screen.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_task_complete_screen.dart';
import 'package:project_gofull/features/driver_service/presentation/screens/driver_rate_customer_screen.dart';
import 'package:project_gofull/features/driver_profile/presentation/screens/driver_privacy_policy_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashScreen(), settings);
      case Routes.login:
        return _buildRoute(const LoginScreen(), settings);
      case Routes.register:
        return _buildRoute(const RegisterScreen(), settings);
      case Routes.home:
        return _buildRoute(BottomNavShell(), settings);
      case Routes.fuelType:
        return _buildRoute(const FuelScreen(), settings);
      case Routes.towingRequest:
        return _buildRoute(const TowingScreen(), settings);
      case Routes.searchingDriver:
        final args = settings.arguments as SearchingArgs;
        return _buildRoute(SearchingScreen(args: args), settings);
      case Routes.driverFound:
        final args = settings.arguments as DriverFoundArgs?;
        return _buildRoute(DriverFoundScreen(args: args), settings);
      case Routes.serviceArrived:
        final args = settings.arguments as ServiceArrivedArgs?;
        return _buildRoute(ServiceArrivedScreen(args: args), settings);
      case Routes.fuelComplete:
        final requestId = settings.arguments as int?;
        return _buildRoute(FuelCompleteScreen(requestId: requestId), settings);
      case Routes.tripDetails:
        final args = settings.arguments as TripDetailsArgs?;
        return _buildRoute(TripDetailsScreen(args: args), settings);
      case Routes.rating:
        final args = settings.arguments as RatingArgs?;
        return _buildRoute(RatingScreen(args: args), settings);
      case Routes.tripInProgress:
        final args = settings.arguments as TripInProgressArgs?;
        return _buildRoute(TripInProgressScreen(args: args), settings);
      case Routes.driverArrived:
        final args = settings.arguments as TripInProgressArgs?;
        return _buildRoute(DriverArrivedScreen(args: args), settings);
      case Routes.towingStarted:
        final args = settings.arguments as TowingStartedArgs?;
        return _buildRoute(TowingStartedScreen(args: args), settings);
      case Routes.towingTripDetails:
        final args = settings.arguments as TripDetailsArgs?;
        return _buildRoute(TowingTripDetailsScreen(args: args), settings);
      case Routes.camera:
        return _buildRoute(const CameraScreen(), settings);
      case Routes.locationPicker:
        return _buildRoute(const LocationPickerScreen(), settings);
      case Routes.locationSearch:
        final args = settings.arguments as LocationSearchArgs;
        return _buildRoute(LocationSearchScreen(args: args), settings);
      case Routes.mapSelection:
        final args = settings.arguments as MapSelectionArgs;
        return _buildRoute(MapSelectionScreen(args: args), settings);
      case Routes.discountCodes:
        return _buildRoute(const DiscountCodesScreen(), settings);
      case Routes.faq:
        return _buildRoute(const FaqScreen(), settings);
      case Routes.terms:
        return _buildRoute(const TermsScreen(), settings);
      case Routes.editProfile:
        return _buildRoute(const EditProfileScreen(), settings);
      case Routes.support:
        return _buildRoute(const SupportScreen(), settings);
      case Routes.privacyPolicy:
        return _buildRoute(const PrivacyPolicyScreen(), settings);
      case Routes.aboutApp:
        return _buildRoute(const AboutScreen(), settings);
      case Routes.notifications:
        return _buildRoute(const NotificationsScreen(), settings);

      // ── Driver App Routes ──────────────────────────────
      case Routes.driverHome:
        return _buildRoute(const DriverHomeScreen(), settings);
      case Routes.driverProfile:
        return _buildRoute(const DriverProfileScreen(), settings);
      case Routes.driverReports:
        return _buildRoute(const DriverReportsScreen(), settings);
      case Routes.driverOrders:
        return _buildRoute(const DriverOrdersScreen(), settings);
      case Routes.driverSupport:
        return _buildRoute(const DriverSupportScreen(), settings);
      case Routes.driverOrderDetails:
        final args = settings.arguments as DriverOrderDetailsArgs;
        return _buildRoute(DriverOrderDetailsScreen(args: args), settings);
      case Routes.driverNavigate:
        final args = settings.arguments as DriverNavigateArgs;
        return _buildRoute(DriverNavigateScreen(args: args), settings);
      case Routes.driverDocumentation:
        final args = settings.arguments as DriverDocumentationArgs;
        return _buildRoute(DriverDocumentationScreen(args: args), settings);
      case Routes.driverRefueling:
        final args = settings.arguments as DriverRefuelingArgs;
        return _buildRoute(DriverRefuelingScreen(args: args), settings);
      case Routes.driverCollectPayment:
        final args = settings.arguments as DriverCollectPaymentArgs;
        return _buildRoute(DriverCollectPaymentScreen(args: args), settings);
      case Routes.driverTaskComplete:
        final args = settings.arguments as DriverTaskCompleteArgs;
        return _buildRoute(DriverTaskCompleteScreen(args: args), settings);
      case Routes.driverRateCustomer:
        final args = settings.arguments as DriverRateArgs;
        return _buildRoute(DriverRateCustomerScreen(args: args), settings);
      case Routes.driverTripDetails:
        final args = settings.arguments as DriverTripDetailsArgs;
        return _buildRoute(DriverTripDetailsScreen(args: args), settings);
      case Routes.driverPrivacyPolicy:
        return _buildRoute(const DriverPrivacyPolicyScreen(), settings);

      default:
        return _undefinedRoute();
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => page, settings: settings);

  static Route<dynamic> _undefinedRoute() => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text(S.of(context).pageNotFound)),
        ),
      );
}
