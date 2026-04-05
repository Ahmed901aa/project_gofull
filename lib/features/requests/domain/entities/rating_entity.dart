import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  final int id;
  final int requestId;
  final int rating;
  final String? comment;
  final String? createdAt;

  const RatingEntity({
    required this.id,
    required this.requestId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, requestId, rating];
}
