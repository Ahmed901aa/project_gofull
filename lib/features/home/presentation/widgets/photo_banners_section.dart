import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/app_config/domain/entities/banner_entity.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// CAFU-style big photo banners at the bottom of the home page.
///
/// Images come from the backend (`/home` → banners with `full_image_url`,
/// admin-managed, cached on device). When the backend hasn't provided any
/// photo banners yet, the two bundled Libyan station photos are shown so
/// the section never looks broken.
class PhotoBannersSection extends StatelessWidget {
  final List<BannerEntity> banners;
  const PhotoBannersSection({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final photoBanners = banners.where((b) => b.hasImage).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: Sizes.s12),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: Insets.s8),
              Text(
                l10n.partnerStationsTitle,
                style: getBoldStyle(
                  color: context.colors.textPrimary,
                  fontSize: FontSize.s18,
                ),
              ),
            ],
          ),
        ),
        if (photoBanners.isNotEmpty)
          for (var i = 0; i < photoBanners.length; i++) ...[
            if (i > 0) SizedBox(height: Insets.s12),
            _PhotoBannerCard(
              title: _localize(photoBanners[i].title, l10n),
              subtitle: photoBanners[i].subtitle == null
                  ? null
                  : _localize(photoBanners[i].subtitle!, l10n),
              imageUrl: photoBanners[i].imageUrl!,
              // Design request: the first photo's composition should face
              // the other way in Arabic.
              mirrorInRtl: i == 0,
            ),
          ]
        else ...[
          // Fallback: bundled station photos until the backend provides some
          _PhotoBannerCard(
            title: l10n.rahilaStation,
            assetPath: 'assets/images/rahila_station.jpg',
            mirrorInRtl: true,
          ),
          SizedBox(height: Insets.s12),
          _PhotoBannerCard(
            title: l10n.shararaStation,
            assetPath: 'assets/images/sharara_station.jpg',
          ),
        ],
      ],
    );
  }
}

/// Backend banner text is stored in Arabic only. Map the known seeded
/// strings to localized equivalents so language switching works; unknown
/// (admin-added) text falls through unchanged.
String _localize(String text, S l10n) {
  switch (text.trim()) {
    case 'محطة الراحلة':
      return l10n.rahilaStation;
    case 'محطة الشرارة':
      return l10n.shararaStation;
    case 'شريك التزوّد بالوقود في ليبيا':
      return l10n.rahilaStationSubtitle;
    case 'شركة الشرارة الذهبية للخدمات النفطية':
      return l10n.shararaStationSubtitle;
    case 'عروض وخصومات GoFull':
      return l10n.gofullOffersTitle;
    case 'خصم على خدمة الساحبة — اطلب الآن':
      return l10n.gofullOffersSubtitle;
    default:
      return text;
  }
}

class _PhotoBannerCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? assetPath;

  /// Flip the photo horizontally when the app runs in Arabic (RTL).
  final bool mirrorInRtl;

  const _PhotoBannerCard({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.assetPath,
    this.mirrorInRtl = false,
  });

  Widget _image(BuildContext context) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(context, loading: true),
        errorWidget: (_, __, ___) => _placeholder(context),
      );
    }
    return Image.asset(
      assetPath!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context, {bool loading = false}) {
    return Container(
      color: context.colors.primary.withValues(alpha: 0.10),
      child: Center(
        child: loading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colors.primary.withValues(alpha: 0.6),
                ),
              )
            : Icon(
                Icons.local_gas_station_rounded,
                size: 48.sp,
                color: context.colors.primary.withValues(alpha: 0.5),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.s24),
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode
                ? Colors.black.withValues(alpha: 0.35)
                : context.colors.shadow.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.s24),
        child: SizedBox(
          height: 168.h,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (mirrorInRtl &&
                  Directionality.of(context) == TextDirection.rtl)
                Transform.flip(flipX: true, child: _image(context))
              else
                _image(context),
              // Bottom gradient so the text stays readable over the photo
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.45, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.70),
                      ],
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: Insets.s16,
                end: Insets.s16,
                bottom: Insets.s12,
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withValues(alpha: 0.18),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Icon(
                        Icons.local_gas_station_rounded,
                        size: 17.sp,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: Insets.s8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              color: AppColors.white,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          if (subtitle != null && subtitle!.isNotEmpty)
                            Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getRegularStyle(
                                color: AppColors.white.withValues(alpha: 0.8),
                                fontSize: FontSize.s12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
