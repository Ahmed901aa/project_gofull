import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/features/shell/presentation/widgets/nav_item.dart';

/// The customer shell's bottom bar is a floating capsule: inset from the
/// screen edges, lifted with a shadow, icon-only, with a green selection
/// pill that slides between tabs and a ringed avatar for the profile tab.
void main() {
  // The palettes are private to app_theme.dart; read them back off the
  // built themes so the test asserts against the real tokens.
  final lightColors = buildLightTheme().extension<AppThemeColors>()!;
  final darkColors = buildDarkTheme().extension<AppThemeColors>()!;

  const items = [
    InstaNavDestination.glyph(InstaGlyph.home, label: 'الرئيسية'),
    InstaNavDestination.glyph(InstaGlyph.orders, label: 'طلباتي'),
    InstaNavDestination.glyph(InstaGlyph.support, label: 'الدعم'),
    InstaNavDestination.avatar(label: 'حسابي', avatarInitial: 'ا'),
  ];

  Widget harness({
    required int current,
    ValueChanged<int>? onTap,
    TextDirection direction = TextDirection.rtl,
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme ?? buildLightTheme(),
      home: Directionality(
        textDirection: direction,
        child: Scaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: InstaNavBar(
            currentIndex: current,
            onTap: onTap ?? (_) {},
            items: items,
          ),
        ),
      ),
    );
  }

  InstaGlyphIcon glyphOf(WidgetTester t, InstaGlyph g) =>
      t.widget<InstaGlyphIcon>(
          find.byWidgetPredicate((w) => w is InstaGlyphIcon && w.glyph == g));

  Finder glyphFinder(InstaGlyph g) =>
      find.byWidgetPredicate((w) => w is InstaGlyphIcon && w.glyph == g);

  BoxDecoration barDecoration(WidgetTester t) => t
      .widget<DecoratedBox>(find
          .descendant(
              of: find.byType(InstaNavBar), matching: find.byType(DecoratedBox))
          .first)
      .decoration as BoxDecoration;

  testWidgets('icon-only: three line glyphs, one avatar, no labels',
      (tester) async {
    await tester.pumpWidget(harness(current: 0));
    expect(find.byType(InstaGlyphIcon), findsNWidgets(3));
    expect(find.byType(InstaAvatarIcon), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
    expect(find.text('الرئيسية'), findsNothing);
    expect(find.text('طلباتي'), findsNothing);
  });

  testWidgets('the selected glyph is green; the others stay subtle grey',
      (tester) async {
    await tester.pumpWidget(harness(current: 0));
    await tester.pumpAndSettle();

    final colors = lightColors;
    expect(glyphOf(tester, InstaGlyph.home).active, isTrue);
    expect(glyphOf(tester, InstaGlyph.home).ink, colors.primary);
    expect(glyphOf(tester, InstaGlyph.orders).active, isFalse);
    expect(glyphOf(tester, InstaGlyph.orders).ink, colors.iconSecondary);
    expect(glyphOf(tester, InstaGlyph.support).ink, colors.iconSecondary);

    await tester.pumpWidget(harness(current: 1));
    await tester.pumpAndSettle();
    expect(glyphOf(tester, InstaGlyph.home).active, isFalse);
    expect(glyphOf(tester, InstaGlyph.home).ink, colors.iconSecondary);
    expect(glyphOf(tester, InstaGlyph.orders).active, isTrue);
    expect(glyphOf(tester, InstaGlyph.orders).ink, colors.primary);
  });

  testWidgets('selection colour animates rather than snapping', (tester) async {
    await tester.pumpWidget(harness(current: 0));
    await tester.pumpAndSettle();

    await tester.pumpWidget(harness(current: 1));
    await tester.pump(const Duration(milliseconds: 100));

    // Mid-flight the incoming glyph is neither fully grey nor fully green.
    final mid = glyphOf(tester, InstaGlyph.orders).ink;
    expect(mid, isNot(lightColors.iconSecondary));
    expect(mid, isNot(lightColors.primary));

    await tester.pumpAndSettle();
    expect(glyphOf(tester, InstaGlyph.orders).ink, lightColors.primary);
  });

  testWidgets('the green selection pill slides to the tapped tab',
      (tester) async {
    await tester.pumpWidget(harness(current: 0));
    await tester.pumpAndSettle();
    final first = tester.getCenter(find.byType(FractionallySizedBox));

    await tester.pumpWidget(harness(current: 2));
    await tester.pump(const Duration(milliseconds: 80));
    final moving = tester.getCenter(find.byType(FractionallySizedBox));
    expect(moving.dx, isNot(first.dx)); // in motion, not teleported

    await tester.pumpAndSettle();
    final settled = tester.getCenter(find.byType(FractionallySizedBox));
    expect(settled.dx,
        moreOrLessEquals(tester.getCenter(glyphFinder(InstaGlyph.support)).dx));
  });

  testWidgets('profile tab shows the initial and rings itself when selected',
      (tester) async {
    await tester.pumpWidget(harness(current: 0));
    await tester.pumpAndSettle();
    expect(find.text('ا'), findsOneWidget);
    expect(tester.widget<InstaAvatarIcon>(find.byType(InstaAvatarIcon)).active,
        isFalse);

    await tester.pumpWidget(harness(current: 3));
    await tester.pumpAndSettle();
    final avatar =
        tester.widget<InstaAvatarIcon>(find.byType(InstaAvatarIcon));
    expect(avatar.active, isTrue);
    expect(avatar.ink, lightColors.primary);
  });

  testWidgets('tapping a tab reports its index', (tester) async {
    int? tapped;
    await tester.pumpWidget(harness(current: 0, onTap: (i) => tapped = i));
    await tester.tap(glyphFinder(InstaGlyph.support));
    await tester.pump();
    expect(tapped, 2);
  });

  testWidgets('labels survive as accessibility names', (tester) async {
    await tester.pumpWidget(harness(current: 3));
    expect(tester.getSemantics(find.bySemanticsLabel('حسابي')),
        isSemantics(label: 'حسابي', isButton: true, isSelected: true));
    expect(tester.getSemantics(find.bySemanticsLabel('الرئيسية')),
        isSemantics(label: 'الرئيسية', isSelected: false));
  });

  testWidgets('RTL: home sits at the trailing (right) edge, pill follows it',
      (tester) async {
    await tester.pumpWidget(harness(current: 0));
    await tester.pumpAndSettle();
    final home = tester.getCenter(glyphFinder(InstaGlyph.home));
    final avatar = tester.getCenter(find.byType(InstaAvatarIcon));
    expect(home.dx, greaterThan(avatar.dx));
    expect(tester.getCenter(find.byType(FractionallySizedBox)).dx,
        moreOrLessEquals(home.dx));
  });

  testWidgets('LTR: home sits at the leading (left) edge, pill follows it',
      (tester) async {
    await tester
        .pumpWidget(harness(current: 0, direction: TextDirection.ltr));
    await tester.pumpAndSettle();
    final home = tester.getCenter(glyphFinder(InstaGlyph.home));
    final avatar = tester.getCenter(find.byType(InstaAvatarIcon));
    expect(home.dx, lessThan(avatar.dx));
    expect(tester.getCenter(find.byType(FractionallySizedBox)).dx,
        moreOrLessEquals(home.dx));
  });

  testWidgets('floats: inset from both edges, rounded, and shadowed',
      (tester) async {
    await tester.pumpWidget(harness(current: 0));
    await tester.pumpAndSettle();

    final screen = tester.getSize(find.byType(MaterialApp)).width;
    // .first is the capsule itself; the second DecoratedBox is the pill.
    final bar = tester.getRect(find
        .descendant(
            of: find.byType(InstaNavBar), matching: find.byType(DecoratedBox))
        .first);
    final inset = InstaNavBar.sideInset(screen);

    expect(bar.left, moreOrLessEquals(inset));
    expect(bar.right, moreOrLessEquals(screen - inset));
    expect(bar.bottom, lessThan(tester.getSize(find.byType(MaterialApp)).height));

    final deco = barDecoration(tester);
    expect(deco.color, lightColors.surface);
    expect(deco.borderRadius,
        BorderRadius.circular(InstaNavBar.resolveHeight(screen) / 2));
    expect(deco.boxShadow, isNotEmpty);
  });

  testWidgets('dark mode keeps a shadow so the capsule still lifts',
      (tester) async {
    await tester.pumpWidget(
        harness(current: 0, theme: buildDarkTheme()));
    await tester.pumpAndSettle();
    final deco = barDecoration(tester);
    expect(deco.color, darkColors.surface);
    expect(deco.boxShadow, isNotEmpty);
    expect(deco.boxShadow!.first.color.a, greaterThan(0));
    expect(glyphOf(tester, InstaGlyph.home).ink, darkColors.primary);
  });

  testWidgets('responsive: the capsule adapts to small and large screens',
      (tester) async {
    expect(InstaNavBar.resolveHeight(320), lessThan(InstaNavBar.barHeight));
    expect(InstaNavBar.resolveHeight(390), InstaNavBar.barHeight);
    expect(InstaNavBar.resolveHeight(800), greaterThan(InstaNavBar.barHeight));
    expect(InstaNavBar.sideInset(320), moreOrLessEquals(14.4));
    expect(InstaNavBar.sideInset(1200), 28.0); // clamped, not sprawling
  });
}
