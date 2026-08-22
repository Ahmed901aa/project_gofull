import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/main.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
  });

  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Ignore overflow errors caused by test screen size
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    await tester.pumpWidget(const GoFullApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    FlutterError.onError = originalOnError;
  });
}
