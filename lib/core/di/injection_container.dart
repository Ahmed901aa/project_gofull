import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/services/token_storage.dart';

// Auth
import 'package:project_gofull/features/auth/data/datasources/auth_data_source.dart';
import 'package:project_gofull/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:project_gofull/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_gofull/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_gofull/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_gofull/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_bloc.dart';

// Home
import 'package:project_gofull/features/home/data/datasources/home_data_source.dart';
import 'package:project_gofull/features/home/data/repositories/home_repository_impl.dart';
import 'package:project_gofull/features/home/domain/repositories/home_repository.dart';
import 'package:project_gofull/features/home/domain/usecases/get_offers_usecase.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_bloc.dart';

// Requests (Customer / Driver side)
import 'package:project_gofull/features/requests/data/datasources/request_data_source.dart';
import 'package:project_gofull/features/requests/data/repositories/request_repository_impl.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';
import 'package:project_gofull/features/requests/domain/usecases/create_fuel_request_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/create_towing_request_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/get_requests_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/get_request_details_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/cancel_request_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/rate_provider_usecase.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';

// App Config
import 'package:project_gofull/features/app_config/data/datasources/app_config_data_source.dart';
import 'package:project_gofull/features/app_config/data/repositories/app_config_repository_impl.dart';
import 'package:project_gofull/features/app_config/domain/repositories/app_config_repository.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';

// Provider
import 'package:project_gofull/features/provider/data/datasources/provider_data_source.dart';
import 'package:project_gofull/features/provider/data/repositories/provider_repository_impl.dart';
import 'package:project_gofull/features/provider/domain/repositories/provider_repository.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_profile_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/toggle_availability_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_active_request_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_pending_requests_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_history_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/accept_request_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/reject_request_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/update_status_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/rate_driver_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/cancel_order_usecase.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';

// Notifications
import 'package:project_gofull/core/cubits/locale_cubit.dart';
import 'package:project_gofull/core/cubits/theme_cubit.dart';
import 'package:project_gofull/features/notifications/data/datasources/notification_data_source.dart';
import 'package:project_gofull/features/notifications/presentation/bloc/notification_bloc.dart';

final sl = GetIt.instance;

/// Toggle this to switch between mock and real data sources.
const bool useMockData = false;

Future<void> initDependencies() async {
  // ── External ─────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ── Core Services ────────────────────────────────────────
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));

  // ── Feature: Auth ────────────────────────────────────────
  sl.registerLazySingleton<AuthDataSource>(
    () => useMockData
        ? AuthMockDataSource()
        : AuthRemoteDataSource(apiClient: sl(), tokenStorage: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      tokenStorage: sl(),
    ),
  );

  // ── Feature: App Config ──────────────────────────────────
  sl.registerLazySingleton<AppConfigDataSource>(
    () => AppConfigRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<AppConfigRepository>(
    () => AppConfigRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(
    () => AppConfigBloc(repository: sl()),
  );

  // ── Feature: Home ────────────────────────────────────────
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

  // ── Feature: Requests (Customer side) ────────────────────
  sl.registerLazySingleton<RequestDataSource>(
    () => useMockData
        ? RequestMockDataSource()
        : RequestRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateFuelRequestUseCase(sl()));
  sl.registerLazySingleton(() => CreateTowingRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetRequestsUseCase(sl()));
  sl.registerLazySingleton(() => GetRequestDetailsUseCase(sl()));
  sl.registerLazySingleton(() => CancelRequestUseCase(sl()));
  sl.registerLazySingleton(() => RateProviderUseCase(sl()));
  sl.registerFactory(
    () => RequestBloc(
      createFuel: sl(),
      createTowing: sl(),
      getRequests: sl(),
      getDetails: sl(),
      cancelRequest: sl(),
      rateProvider: sl(),
      repository: sl(),
    ),
  );

  // ── Feature: Provider ────────────────────────────────────
  sl.registerLazySingleton<ProviderDataSource>(
    () => useMockData
        ? ProviderMockDataSource()
        : ProviderRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ProviderRepository>(
    () => ProviderRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => ToggleAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetPendingRequestsUseCase(sl()));
  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AcceptRequestUseCase(sl()));
  sl.registerLazySingleton(() => RejectRequestUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStatusUseCase(sl()));
  sl.registerLazySingleton(() => RateDriverUseCase(sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(sl()));
  // ── Feature: Notifications ──────────────────────────────
  sl.registerLazySingleton<NotificationDataSource>(
    () => NotificationRemoteDataSource(sl()),
  );
  sl.registerFactory(
    () => NotificationBloc(dataSource: sl()),
  );

  sl.registerFactory(
    () => ProviderBloc(
      getProfile: sl(),
      toggleAvailability: sl(),
      getActiveRequest: sl(),
      getPendingRequests: sl(),
      getHistory: sl(),
      acceptRequest: sl(),
      rejectRequest: sl(),
      updateStatus: sl(),
      rateDriver: sl(),
      cancelOrder: sl(),
    ),
  );
}
