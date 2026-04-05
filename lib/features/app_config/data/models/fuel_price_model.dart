import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';

class FuelPriceModel extends FuelPriceEntity {
  const FuelPriceModel({
    required super.id,
    required super.fuelType,
    required super.nameAr,
    required super.pricePerLiter,
  });

  factory FuelPriceModel.fromJson(Map<String, dynamic> json) => FuelPriceModel(
        id: json['id'] as int,
        fuelType: json['fuel_type'] as String,
        nameAr: json['name_ar'] as String,
        pricePerLiter: double.parse(json['price_per_liter'].toString()),
      );
}
