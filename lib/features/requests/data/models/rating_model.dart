import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  const RatingModel({
    required super.id,
    required super.requestId,
    required super.rating,
    super.comment,
    super.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        id: json['id'] as int,
        requestId: json['request_id'] as int,
        rating: json['rating'] as int,
        comment: json['comment'] as String?,
        createdAt: json['created_at'] as String?,
      );
}
