import 'package:project_gofull/features/app_config/domain/repositories/app_config_repository.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppConfigRepository repository;

  AppConfigBloc({required this.repository}) : super(const AppConfigState()) {
    on<LoadAppConfigEvent>(_onLoadConfig);
    on<LoadHomeDataEvent>(_onLoadHome);
  }

  /// Load fuel prices + app settings (called once at startup).
  Future<void> _onLoadConfig(
      LoadAppConfigEvent event, Emitter<AppConfigState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Fetch in parallel
    final fuelResult = await repository.getFuelPrices();
    final settingsResult = await repository.getAppSettings();

    emit(state.copyWith(
      isLoading: false,
      fuelPrices: fuelResult.fold((_) => state.fuelPrices, (v) => v),
      settings: settingsResult.fold((_) => state.settings, (v) => v),
    ));
  }

  /// Load home page data (banners + active order).
  Future<void> _onLoadHome(
      LoadHomeDataEvent event, Emitter<AppConfigState> emit) async {
    final result = await repository.getHomeData();
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (data) => emit(state.copyWith(
        banners: data.banners,
        activeOrder: data.activeOrder,
        clearActiveOrder: data.activeOrder == null,
      )),
    );
  }
}
