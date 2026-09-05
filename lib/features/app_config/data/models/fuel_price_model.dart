import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';

class FuelPriceModel extends FuelPriceEntity {
  const FuelPriceModel({
    required super.id,
    required super.fuelType,
    required super.nameAr,
    required super.pricePerLiter,
    super.priceWithTax,
  });

  // Tolerant of wire-type drift (Laravel sends decimals as strings, ints
  // as ints) — a single malformed row must not kill the whole price list.
  factory FuelPriceModel.fromJson(Map<String, dynamic> json) => FuelPriceModel(
        id: int.tryParse('${json['id']}') ?? 0,
        fuelType: '${json['fuel_type'] ?? ''}',
        nameAr: '${json['name_ar'] ?? ''}',
        pricePerLiter: double.tryParse('${json['price_per_liter']}') ?? 0,
        priceWithTax: json['price_with_tax'] != null
            ? double.tryParse('${json['price_with_tax']}')
            : null,
      );
}
