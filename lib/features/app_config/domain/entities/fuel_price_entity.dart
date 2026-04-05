import 'package:equatable/equatable.dart';

class FuelPriceEntity extends Equatable {
  final int id;
  final String fuelType;
  final String nameAr;
  final double pricePerLiter;

  const FuelPriceEntity({
    required this.id,
    required this.fuelType,
    required this.nameAr,
    required this.pricePerLiter,
  });

  @override
  List<Object?> get props => [id, fuelType, pricePerLiter];
}
