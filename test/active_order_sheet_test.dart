import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/features/app_config/domain/entities/banner_entity.dart';
import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';
import 'package:project_gofull/features/app_config/domain/repositories/app_config_repository.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/widgets/active_order_sheet.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Repository double: the sheet never calls it directly, but AppConfigBloc
/// needs one, and LoadHomeDataEvent fires when the sheet opens.
class _FakeRepo implements AppConfigRepository {
  final ServiceRequestEntity? active;
  _FakeRepo(this.active);

  @override
  Future<Either<Failure, List<FuelPriceEntity>>> getFuelPrices() async =>
      const Right([]);

  @override
  Future<Either<Failure, Map<String, String>>> getAppSettings() async =>
      const Right({});

  @override
  Future<Either<Failure, ({List<BannerEntity> banners, ServiceRequestEntity? activeOrder})>>
      getHomeData() async => Right((banners: <BannerEntity>[], activeOrder: active));
}

ServiceRequestEntity _order({
  int id = 4821,
  String serviceType = 'towing',
  String status = 'en_route',
  Map<String, dynamic>? provider,
}) =>
    ServiceRequestEntity(
      id: id,
      driverId: 1,
      serviceType: serviceType,
      status: status,
      driverLatitude: '32.09',
      driverLongitude: '20.06',
      providerInfo: provider,
    );

/// Pumps a screen with a button that opens the sheet, so the real
/// showActiveOrderSheet() entry point is exercised (including its
/// re-entrancy guard).
Future<void> _pumpHost(
  WidgetTester tester, {
  required ServiceRequestEntity? active,
  Locale locale = const Locale('en'),
}) async {
  // A real phone surface: the default 800x600 test window makes
  // ScreenUtil scale every .w/.sp by ~2x and blows the layout apart.
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final bloc = AppConfigBloc(repository: _FakeRepo(active));
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => BlocProvider.value(
        value: bloc,
        child: MaterialApp(
          locale: locale,
          supportedLocales: S.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: buildLightTheme(),
          home: Builder(
            builder: (ctx) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showActiveOrderSheet(ctx),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  // A test may end with the sheet still open; its future never resolves,
  // so the guard's `finally` never runs. Clear it between tests.
  setUp(debugResetActiveOrderSheetGuard);

  testWidgets('shows title, body and both actions', (tester) async {
    await _pumpHost(tester, active: _order());
    await _open(tester);

    final l10n = await S.delegate.load(const Locale('en'));
    expect(find.text(l10n.activeOrderTitle), findsOneWidget);
    expect(find.text(l10n.activeOrderSheetBody), findsOneWidget);
    expect(find.text(l10n.viewCurrentOrder), findsOneWidget);
    expect(find.text(l10n.closeBtn), findsOneWidget);
    // It is a sheet, not an AlertDialog.
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('summarises the blocking order (type, number, status)',
      (tester) async {
    await _pumpHost(
      tester,
      active: _order(
        id: 4821,
        serviceType: 'towing',
        status: 'en_route',
        provider: {
          'user': {'name': 'مفتاح صالح'}
        },
      ),
    );
    await _open(tester);

    final l10n = await S.delegate.load(const Locale('en'));
    expect(find.text(l10n.towingService), findsOneWidget);
    expect(find.text('#4821'), findsOneWidget);
    expect(find.text(l10n.enRoute), findsOneWidget);
    expect(find.text('مفتاح صالح'), findsOneWidget);
    // Towing shows the app's own tow-truck artwork.
    expect(find.byType(TowTruckIcon), findsOneWidget);
  });

  testWidgets('fuel order shows the fuel glyph, not the truck',
      (tester) async {
    await _pumpHost(tester, active: _order(serviceType: 'fuel_delivery'));
    await _open(tester);

    expect(find.byIcon(Icons.local_gas_station_rounded), findsOneWidget);
    expect(find.byType(TowTruckIcon), findsNothing);
  });

  testWidgets('renders correctly in Arabic RTL', (tester) async {
    await _pumpHost(tester, active: _order(), locale: const Locale('ar'));
    await _open(tester);

    final ar = await S.delegate.load(const Locale('ar'));
    expect(find.text(ar.activeOrderTitle), findsOneWidget);
    expect(find.text(ar.viewCurrentOrder), findsOneWidget);
    expect(find.text(ar.closeBtn), findsOneWidget);

    // Sheet content lays out right-to-left.
    final dir = Directionality.of(
        tester.element(find.text(ar.activeOrderTitle)));
    expect(dir, TextDirection.rtl);

    // The order number keeps LTR digit order even inside an RTL sheet.
    final numberDir =
        Directionality.of(tester.element(find.text('#4821')));
    expect(numberDir, TextDirection.ltr);
  });

  testWidgets('Close dismisses without navigating', (tester) async {
    await _pumpHost(tester, active: _order());
    await _open(tester);

    final l10n = await S.delegate.load(const Locale('en'));
    await tester.tap(find.text(l10n.closeBtn));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('cannot stack a second sheet (double tap guard)',
      (tester) async {
    await _pumpHost(tester, active: _order());

    // Two taps in the same frame, as a fast double tap would produce.
    await tester.tap(find.text('open'));
    await tester.tap(find.text('open'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('no order details available still renders a usable sheet',
      (tester) async {
    await _pumpHost(tester, active: null);
    await _open(tester);

    final l10n = await S.delegate.load(const Locale('en'));
    expect(find.text(l10n.activeOrderTitle), findsOneWidget);
    expect(find.text(l10n.viewCurrentOrder), findsOneWidget);
  });
}
