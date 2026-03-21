import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    required super.id,
    required super.title,
    required super.code,
    required super.colorValue,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as String,
        title: json['title'] as String,
        code: json['code'] as String,
        colorValue: json['color'] as int,
      );
}
