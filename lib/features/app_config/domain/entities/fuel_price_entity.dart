import 'package:equatable/equatable.dart';

class FuelPriceEntity extends Equatable {
  final int id;
  final String fuelType;
  final String nameAr;
  final double pricePerLiter;

  /// Price per liter including tax (falls back to [pricePerLiter] when the
  /// backend doesn't send it).
  final double priceWithTax;

  const FuelPriceEntity({
    required this.id,
    required this.fuelType,
    required this.nameAr,
    required this.pricePerLiter,
    double? priceWithTax,
  }) : priceWithTax = priceWithTax ?? pricePerLiter;

  @override
  List<Object?> get props => [id, fuelType, pricePerLiter, priceWithTax];
}
