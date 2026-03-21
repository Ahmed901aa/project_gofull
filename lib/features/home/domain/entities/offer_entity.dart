import 'package:equatable/equatable.dart';

class OfferEntity extends Equatable {
  final String id;
  final String title;
  final String code;
  final int colorValue;

  const OfferEntity({
    required this.id,
    required this.title,
    required this.code,
    required this.colorValue,
  });

  @override
  List<Object?> get props => [id, title, code, colorValue];
}
