import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class BannerData {
  final List<Color> gradientColors;
  final String headline;
  final String headlineAccent;
  final String badge;
  final String tag;
  final IconData icon;
  final String ctaLabel;
  final String image;
  final bool flipImageInRtl;
  const BannerData({
    required this.gradientColors,
    required this.headline,
    required this.headlineAccent,
    required this.badge,
    required this.tag,
    required this.icon,
    required this.ctaLabel,
    required this.image,
    this.flipImageInRtl = false,
  });
}

List<BannerData> getBannerSlides(BuildContext context) {
  final l10n = S.of(context);
  return [
    BannerData(
      gradientColors: [context.colors.gold, Color(0xFFE1A200), Color(0xFF996E00)],
      headline: l10n.bannerAllServicesIn,
      headlineAccent: l10n.bannerOneSubscription,
      badge: l10n.bannerFreeVouchers,
      tag: l10n.bannerExclusiveOffer,
      icon: Icons.workspace_premium_rounded,
      ctaLabel: l10n.subscribeNow,
      image: ImageAssets.bannerPremium,
    ),
    BannerData(
      gradientColors: [context.colors.primaryLight, context.colors.primary, Color(0xFF003329)],
      headline: l10n.bannerTowRoundClock,
      headlineAccent: l10n.bannerTwentyFourHours,
      badge: l10n.bannerFastResponse,
      tag: l10n.bannerAvailableNow,
      icon: Icons.fire_truck_rounded,
      ctaLabel: l10n.orderNow,
      image: ImageAssets.promoTruck,
      flipImageInRtl: true,
    ),
    BannerData(
      gradientColors: [Color(0xFF2979FF), Color(0xFF1565C0), Color(0xFF0D47A1)],
      headline: l10n.bannerGetDiscount,
      headlineAccent: l10n.bannerTwentyPercent,
      badge: l10n.bannerUseCodeGO20,
      tag: l10n.bannerLimitedTime,
      icon: Icons.local_offer_rounded,
      ctaLabel: l10n.useCodeBtn,
      image: ImageAssets.bannerDiscount,
    ),
  ];
}
