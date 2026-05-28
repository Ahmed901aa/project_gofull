import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/cubits/locale_cubit.dart';
import 'package:project_gofull/core/cubits/theme_cubit.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/routes/route_generator.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/noti_service.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initDependencies();
  await NotiService().initNotification();
  runApp(const GoFullApp());
}

class GoFullApp extends StatelessWidget {
  const GoFullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocationCubit()),
        BlocProvider(create: (_) => sl<LocaleCubit>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(
          create: (_) =>
              sl<AppConfigBloc>()..add(const LoadAppConfigEvent()),
        ),
      ],
      // Rebuild on both locale AND theme changes
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          final isArabic = locale.languageCode == 'ar';
          final fontFamily = FontConstants.forLocale(locale);
          FontSize.setLocaleScale(locale);

          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                builder: (context, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'GoFull',
                  locale: locale,
                  supportedLocales: S.supportedLocales,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],

                  // ── Theme system ──
                  themeMode: themeMode,
                  theme: buildLightTheme(fontFamily: fontFamily),
                  darkTheme: buildDarkTheme(fontFamily: fontFamily),

                  builder: (context, child) => GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    behavior: HitTestBehavior.opaque,
                    child: Directionality(
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      child: child!,
                    ),
                  ),
                  initialRoute: Routes.splash,
                  onGenerateRoute: RouteGenerator.getRoute,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
