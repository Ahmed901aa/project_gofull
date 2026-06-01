import 'package:equatable/equatable.dart';
import 'package:project_gofull/features/app_config/domain/entities/banner_entity.dart';
import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

class AppConfigState extends Equatable {
  final List<FuelPriceEntity> fuelPrices;
  final Map<String, String> settings;
  final List<BannerEntity> banners;
  final ServiceRequestEntity? activeOrder;
  final bool isLoading;
  final String? error;

  const AppConfigState({
    this.fuelPrices = const [],
    this.settings = const {},
    this.banners = const [],
    this.activeOrder,
    this.isLoading = false,
    this.error,
  });

  /// Helper to get a setting value with a fallback.
  String setting(String key, [String fallback = '']) =>
      settings[key] ?? fallback;

  String get currency => setting('currency', 'د.ل');
  String get supportPhone => setting('support_phone', '0915909734');
  double get serviceFee => double.tryParse(setting('service_fee', '15')) ?? 15;
  double get towingBasePrice =>
      double.tryParse(setting('towing_base_price', '50')) ?? 50;

  AppConfigState copyWith({
    List<FuelPriceEntity>? fuelPrices,
    Map<String, String>? settings,
    List<BannerEntity>? banners,
    ServiceRequestEntity? activeOrder,
    bool? isLoading,
    String? error,
    bool clearActiveOrder = false,
  }) {
    return AppConfigState(
      fuelPrices: fuelPrices ?? this.fuelPrices,
      settings: settings ?? this.settings,
      banners: banners ?? this.banners,
      activeOrder: clearActiveOrder ? null : (activeOrder ?? this.activeOrder),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [fuelPrices, settings, banners, activeOrder, isLoading, error];
}
