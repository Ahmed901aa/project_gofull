import 'package:project_gofull/features/app_config/domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.title,
    super.subtitle,
    super.imageUrl,
    super.discountCode,
    super.colorHex,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'] as int,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        imageUrl: json['image_url'] as String?,
        discountCode: json['discount_code'] as String?,
        colorHex: json['color_hex'] as String?,
      );
}
