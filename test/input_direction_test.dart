import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/features/auth/presentation/widgets/phone_input_field.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Phone and password fields pin `textDirection` to LTR so digits and latin
/// never reorder. Alignment must NOT follow that override — it follows the
/// locale, or the hint and the caret end up on opposite sides of the field.
void main() {
  Widget host(Locale locale, Widget child) => MaterialApp(
        theme: buildLightTheme(),
        locale: locale,
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        home: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => Scaffold(body: child),
        ),
      );

  group('context.inputAlign follows the locale, not the field', () {
    for (final (locale, expected) in [
      (const Locale('ar'), TextAlign.right),
      (const Locale('en'), TextAlign.left),
    ]) {
      testWidgets('${locale.languageCode} -> $expected', (tester) async {
        late TextAlign resolved;
        await tester.pumpWidget(host(
          locale,
          Builder(builder: (context) {
            resolved = context.inputAlign;
            return const SizedBox();
          }),
        ));
        expect(resolved, expected);
      });
    }
  });

  testWidgets('Arabic: phone input is LTR but right-aligned', (tester) async {
    await tester.pumpWidget(host(
      const Locale('ar'),
      PhoneInputField(controller: TextEditingController()),
    ));
    final field = tester.widget<TextField>(find.byType(TextField));
    // Digits must not reorder…
    expect(field.textDirection, TextDirection.ltr);
    // …but the number and its hint sit on the Arabic reading side.
    expect(field.textAlign, TextAlign.right);
    // A forced LTR hint would drag the placeholder to the opposite edge.
    expect(field.decoration!.hintTextDirection, isNull);
  });

  testWidgets('English: phone input is LTR and left-aligned', (tester) async {
    await tester.pumpWidget(host(
      const Locale('en'),
      PhoneInputField(controller: TextEditingController()),
    ));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.textDirection, TextDirection.ltr);
    expect(field.textAlign, TextAlign.left);
  });
}
