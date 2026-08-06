import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final int id;
  final String title;

  /// 'promo' → big photo banner, 'service' → home grid tile.
  final String type;

  /// For service tiles: what to open (fuel | towing | emergency).
  final String? action;
  final String? subtitle;
  final String? imageUrl;
  final String? discountCode;
  final String? colorHex;

  const BannerEntity({
    required this.id,
    required this.title,
    this.type = 'promo',
    this.action,
    this.subtitle,
    this.imageUrl,
    this.discountCode,
    this.colorHex,
  });

  bool get isService => type == 'service';

  /// True when the banner has a photo to show (photo banner) rather than
  /// being a plain color/discount card.
  bool get hasImage => imageUrl != null && imageUrl!.startsWith('http');

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
