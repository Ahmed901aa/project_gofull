import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final int id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? discountCode;
  final String? colorHex;

  const BannerEntity({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.discountCode,
    this.colorHex,
  });

  int get colorValue {
    if (colorHex == null) {

      return 0xFF004B3B;

    }
    final hex = colorHex!.replaceFirst('#', '');
    return int.parse('FF$hex', radix: 16);
  }

  @override
  List<Object?> get props => [id, title];
}
