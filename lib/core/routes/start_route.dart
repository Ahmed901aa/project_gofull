import 'package:project_gofull/core/routes/routes.dart';


const String onboardingSeenKey = 'onboarding_seen';


String resolveStartRoute({
  required bool isLoggedIn,
  required String? userRole,
  required bool onboardingSeen,
}) {
  if (isLoggedIn) {
    return userRole == 'provider' ? Routes.driverHome : Routes.home;
  }
  return onboardingSeen ? Routes.login : Routes.onboarding;
}
