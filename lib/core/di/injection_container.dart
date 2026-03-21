import 'package:get_it/get_it.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/features/auth/data/datasources/auth_data_source.dart';
import 'package:project_gofull/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:project_gofull/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_gofull/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:project_gofull/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project_gofull/features/home/data/datasources/home_data_source.dart';
import 'package:project_gofull/features/home/data/repositories/home_repository_impl.dart';
import 'package:project_gofull/features/home/domain/repositories/home_repository.dart';
import 'package:project_gofull/features/home/domain/usecases/get_offers_usecase.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

/// Toggle this to switch between mock and real data sources
const bool useMockData = true;

Future<void> initDependencies() async {
  // ── Core ──────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ── Feature: Auth ─────────────────────────────────────
  sl.registerLazySingleton<AuthDataSource>(
    () => useMockData ? AuthMockDataSource() : AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(sendOtp: sl(), verifyOtp: sl()),
  );

  // ── Feature: Home ─────────────────────────────────────
  sl.registerLazySingleton<HomeDataSource>(
    () => useMockData ? HomeMockDataSource() : HomeRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetOffersUseCase(sl()));
  sl.registerFactory(
    () => HomeBloc(getOffers: sl()),
  );

  // ── Feature: Fuel Delivery ────────────────────────────
  // TODO: Register fuel delivery dependencies

  // ── Feature: Car Towing ───────────────────────────────
  // TODO: Register car towing dependencies
}
