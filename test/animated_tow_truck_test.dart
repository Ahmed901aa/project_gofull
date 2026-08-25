import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/animated_tow_truck.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

/// Renders the widget in a realistic app shell (theme extension + screenutil)
/// at a fixed direction.
Widget _harness({required bool moving, required TextDirection direction}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => MaterialApp(
      theme: buildLightTheme(),
      home: Directionality(
        textDirection: direction,
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 340,
              child: AnimatedTowTruck(moving: moving),
            ),
          ),
        ),
      ),
    ),
  );
}

double _truckX(WidgetTester tester) =>
    tester.getCenter(find.byType(TowTruckIcon)).dx;

void main() {
  testWidgets('renders the existing tow-truck asset, unmodified',
      (tester) async {
    await tester.pumpWidget(_harness(moving: true, direction: TextDirection.ltr));
    await tester.pump();

    // The animation must reuse the app's own truck widget/asset.
    expect(find.byType(TowTruckIcon), findsOneWidget);
    final img = tester.widget<Image>(
      find.descendant(of: find.byType(TowTruckIcon), matching: find.byType(Image)),
    );
    expect((img.image as AssetImage).assetName, 'assets/images/icon_truck.png');
    // No tint is applied — original colours preserved.
    expect(img.color, isNull);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('LTR: truck travels forward (left → right)', (tester) async {
    await tester.pumpWidget(_harness(moving: true, direction: TextDirection.ltr));
    await tester.pump();
    final start = _truckX(tester);

    await tester.pump(const Duration(milliseconds: 1400));
    final mid = _truckX(tester);

    expect(mid, greaterThan(start),
        reason: 'in English the vehicle should advance to the right');
  });

  testWidgets('RTL: truck travels forward (right → left)', (tester) async {
    await tester.pumpWidget(_harness(moving: true, direction: TextDirection.rtl));
    await tester.pump();
    final start = _truckX(tester);

    await tester.pump(const Duration(milliseconds: 1400));
    final mid = _truckX(tester);

    expect(mid, lessThan(start),
        reason: 'in Arabic the vehicle should advance to the left');
  });

  testWidgets('parked status holds the truck completely still', (tester) async {
    await tester.pumpWidget(_harness(moving: false, direction: TextDirection.ltr));
    await tester.pump();
    final a = _truckX(tester);

    await tester.pump(const Duration(milliseconds: 1500));
    final b = _truckX(tester);
    await tester.pump(const Duration(milliseconds: 1500));
    final c = _truckX(tester);

    expect(a, b);
    expect(b, c);
  });

  testWidgets('flipping status to moving starts it, and back parks it',
      (tester) async {
    await tester.pumpWidget(_harness(moving: false, direction: TextDirection.ltr));
    await tester.pump();
    final parked = _truckX(tester);

    // Provider sets the order to in_progress.
    await tester.pumpWidget(_harness(moving: true, direction: TextDirection.ltr));
    await tester.pump(const Duration(milliseconds: 1400));
    expect(_truckX(tester), greaterThan(parked));

    // Order leaves in_progress — vehicle returns to rest.
    await tester.pumpWidget(_harness(moving: false, direction: TextDirection.ltr));
    await tester.pump();
    expect(_truckX(tester), parked);
  });

  testWidgets('a parked truck is fully visible, not faded out',
      (tester) async {
    // Regression: the loop's fade envelope is zero at t=0, which made a
    // stationary ('arrived') order render an invisible truck.
    await tester.pumpWidget(_harness(moving: false, direction: TextDirection.ltr));
    await tester.pump();

    final opacity = tester.widget<Opacity>(
      find.ancestor(
        of: find.byType(TowTruckIcon),
        matching: find.byType(Opacity),
      ).first,
    );
    expect(opacity.opacity, 1.0);
  });

  testWidgets('no ticker is left running after dispose', (tester) async {
    await tester.pumpWidget(_harness(moving: true, direction: TextDirection.ltr));
    await tester.pump(const Duration(milliseconds: 500));

    // Replacing the tree disposes the widget; a leaked controller would
    // make the test framework flag a pending timer/ticker.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(find.byType(AnimatedTowTruck), findsNothing);
  });
}
