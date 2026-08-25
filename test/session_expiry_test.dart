import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/session_expiry.dart';
import 'package:project_gofull/core/utils/tracked_dispatch.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Minimal app shell wired the same way main.dart is, with stub routes so
/// the test does not need the DI container.
Widget _app({Locale locale = const Locale('en')}) => MaterialApp(
      navigatorKey: rootNavigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      locale: locale,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: Routes.driverHome,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (_) => Scaffold(
          body: Center(child: Text('route:${settings.name}')),
        ),
      ),
    );

void main() {
  setUp(debugResetSessionExpiryGuard);

  testWidgets('an expired session lands the user on the login screen',
      (tester) async {
    await tester.pumpWidget(_app());
    expect(find.text('route:${Routes.driverHome}'), findsOneWidget);

    handleSessionExpired();
    await tester.pumpAndSettle();

    expect(find.text('route:${Routes.login}'), findsOneWidget);
    expect(find.text('route:${Routes.driverHome}'), findsNothing);
  });

  testWidgets('shows a localized explanation, not the raw server string',
      (tester) async {
    await tester.pumpWidget(_app(locale: const Locale('ar')));
    handleSessionExpired();
    await tester.pumpAndSettle();

    final ar = await S.delegate.load(const Locale('ar'));
    expect(find.text(ar.sessionExpired), findsOneWidget);
    // Laravel's untranslated message must never reach the user.
    expect(find.text('Unauthenticated.'), findsNothing);
  });

  testWidgets('a burst of 401s produces exactly one redirect',
      (tester) async {
    await tester.pumpWidget(_app());

    // Driver home polls several endpoints at once; one dead token yields
    // several simultaneous 401s.
    handleSessionExpired();
    handleSessionExpired();
    handleSessionExpired();
    await tester.pumpAndSettle();

    expect(find.text('route:${Routes.login}'), findsOneWidget);
    // One snackbar, not three stacked.
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('the whole stack is cleared, so back cannot return to a dead screen',
      (tester) async {
    await tester.pumpWidget(_app());
    final navigator = rootNavigatorKey.currentState!;
    navigator.pushNamed(Routes.driverOrders);
    await tester.pumpAndSettle();
    expect(find.text('route:${Routes.driverOrders}'), findsOneWidget);

    handleSessionExpired();
    await tester.pumpAndSettle();

    expect(find.text('route:${Routes.login}'), findsOneWidget);
    expect(navigator.canPop(), isFalse);
  });
}
