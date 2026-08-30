import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/routes/start_route.dart';
import 'package:project_gofull/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app({Locale locale = const Locale('en')}) => ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: locale,
        supportedLocales: S.supportedLocales,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: buildLightTheme(),
        home: const OnboardingScreen(),
        onGenerateRoute: (s) => MaterialPageRoute(
          settings: s,
          builder: (_) => Scaffold(body: Text('route:${s.name}')),
        ),
      ),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('resolveStartRoute policy', () {
    test('fresh install → onboarding', () {
      expect(
        resolveStartRoute(
            isLoggedIn: false, userRole: null, onboardingSeen: false),
        Routes.onboarding,
      );
    });

    test('seen intro, logged out → login', () {
      expect(
        resolveStartRoute(
            isLoggedIn: false, userRole: null, onboardingSeen: true),
        Routes.login,
      );
    });

    test('logged-in customer skips the intro even on first launch', () {
      expect(
        resolveStartRoute(
            isLoggedIn: true, userRole: 'driver', onboardingSeen: false),
        Routes.home,
      );
    });

    test('logged-in provider goes to driver home', () {
      expect(
        resolveStartRoute(
            isLoggedIn: true, userRole: 'provider', onboardingSeen: true),
        Routes.driverHome,
      );
    });
  });

  testWidgets('walks all 3 pages and finishes to login', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    final l10n = await S.delegate.load(const Locale('en'));

    // Page 1
    expect(find.text(l10n.onbFuelTitle), findsOneWidget);
    await tester.tap(find.text(l10n.nextBtn));
    await tester.pumpAndSettle();

    // Page 2
    expect(find.text(l10n.onbTowingTitle), findsOneWidget);
    await tester.tap(find.text(l10n.nextBtn));
    await tester.pumpAndSettle();

    // Page 3: the button becomes Get Started
    expect(find.text(l10n.onbTrackingTitle), findsOneWidget);
    expect(find.text(l10n.nextBtn), findsNothing);
    await tester.tap(find.text(l10n.getStartedBtn));
    await tester.pumpAndSettle();

    expect(find.text('route:${Routes.login}'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(onboardingSeenKey), isTrue);
  });

  testWidgets('skip persists the flag and goes to login', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    final l10n = await S.delegate.load(const Locale('en'));

    await tester.tap(find.text(l10n.skip));
    await tester.pumpAndSettle();

    expect(find.text('route:${Routes.login}'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(onboardingSeenKey), isTrue);
  });

  testWidgets('renders in Arabic RTL with localized copy', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(locale: const Locale('ar')));
    await tester.pumpAndSettle();
    final ar = await S.delegate.load(const Locale('ar'));

    expect(find.text(ar.onbFuelTitle), findsOneWidget);
    expect(find.text(ar.skip), findsOneWidget);
    expect(find.text(ar.nextBtn), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text(ar.onbFuelTitle))),
      TextDirection.rtl,
    );
  });
}
