import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/features/auth/presentation/screens/splash_screen.dart';

/// Regression test: the branded gradient must cover the entire screen.
///
/// The splash body used to be a `Container` with no explicit size, so it
/// shrank to its 340px glow child and the bottom half of the phone rendered
/// white. This pins the fix.
void main() {
  testWidgets('splash gradient fills the whole screen', (tester) async {
    tester.view.physicalSize = const Size(1206, 2622); // iPhone 16 Pro
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: const SplashScreen(),
        // Splash falls back to the login route when DI is not registered;
        // give it a blank destination so navigation succeeds in the test.
        onGenerateRoute: (_) =>
            MaterialPageRoute<void>(builder: (_) => const SizedBox.shrink()),
      ),
    );
    await tester.pump();

    final screen = tester.getSize(find.byType(Scaffold));
    final gradientBox = tester.getSize(
      find.descendant(
        of: find.byType(Scaffold),
        matching: find.byWidgetPredicate(
          (w) => w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).gradient is LinearGradient,
        ),
      ),
    );

    expect(gradientBox.width, screen.width);
    expect(gradientBox.height, screen.height);

    // Logo sits in the middle of the screen, not the top-left corner.
    final logoCenter = tester.getCenter(find.byType(SvgPicture));
    expect((logoCenter.dx - screen.width / 2).abs(), lessThan(1));

    // Let the branded pause finish and navigate so no timers stay pending.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
