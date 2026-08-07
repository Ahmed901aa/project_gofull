import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/services/reverb_service.dart';
import 'package:project_gofull/features/app_config/data/models/fuel_price_model.dart';
import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';
import 'package:project_gofull/features/app_config/domain/repositories/app_config_repository.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final AppConfigRepository repository;
  final ReverbService? reverb;

  StreamSubscription<ReverbEvent>? _realtimeSub;

  /// Public channel carrying admin-pushed home data (fuel prices +
  /// open-stations counter). No auth needed.
  static const _homeChannel = 'home-data';

  AppConfigBloc({required this.repository, this.reverb})
      : super(const AppConfigState()) {
    on<LoadAppConfigEvent>(_onLoadConfig);
    on<LoadHomeDataEvent>(_onLoadHome);
    on<RealtimeHomeDataEvent>(_onRealtimeData);

    _subscribeRealtime();
  }

  /// Listen for admin updates pushed over Reverb. The socket reconnects
  /// with backoff on its own; [LoadAppConfigEvent] on app resume covers
  /// anything missed while the socket was down.
  void _subscribeRealtime() {
    final service = reverb;
    if (service == null) {
      return;
    }
    _realtimeSub = service.channelStream(_homeChannel).listen((event) {
      if (event.event == 'home.data.updated') {
        add(RealtimeHomeDataEvent(event.data));
      }
    });
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

  /// Apply a snapshot pushed by the admin dashboard. The payload mirrors
  /// the REST endpoints, so it fully REPLACES fuel prices and settings —
  /// idempotent, no client-side merging.
  void _onRealtimeData(
      RealtimeHomeDataEvent event, Emitter<AppConfigState> emit) {
    try {
      final payload = event.payload;

      List<FuelPriceEntity>? fuelPrices;
      final rawPrices = payload['fuel_prices'];
      if (rawPrices is List) {
        fuelPrices = rawPrices
            .whereType<Map<String, dynamic>>()
            .map(FuelPriceModel.fromJson)
            .toList();
      }

      Map<String, String>? settings;
      final rawSettings = payload['settings'];
      if (rawSettings is Map) {
        settings = rawSettings
            .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
      }

      emit(state.copyWith(
        fuelPrices: fuelPrices,
        settings: settings,
      ));
    } catch (e) {
      debugPrint('Realtime home data parse error: $e');
    }
  }

  @override
  Future<void> close() {
    _realtimeSub?.cancel();
    reverb?.leaveChannel(_homeChannel);
    return super.close();
  }
}
