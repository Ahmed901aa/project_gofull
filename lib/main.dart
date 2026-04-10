import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
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
        BlocProvider(
          create: (_) =>
              sl<AppConfigBloc>()..add(const LoadAppConfigEvent()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GoFull',
          locale: const Locale('ar'),
          theme: ThemeData(
            fontFamily: FontConstants.fontFamily,
            scaffoldBackgroundColor: AppColors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
            ),
          ),
          builder: (context, child) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          ),
          initialRoute: Routes.splash,
          onGenerateRoute: RouteGenerator.getRoute,
        ),
      ),
    );
  }
}
