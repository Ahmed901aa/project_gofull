import 'package:project_gofull/core/routes/routes.dart';

/// Key under which "the user has seen the 3-screen intro" is persisted.
const String onboardingSeenKey = 'onboarding_seen';

/// Decides where the splash screen sends the user.
///
/// Pure function so the routing policy is unit-testable without DI:
///   - logged in            → their home (provider vs customer)
///   - logged out, seen intro → login
///   - logged out, fresh install → the 3-screen intro (shown once)
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
