import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/app_config/domain/entities/banner_entity.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Home services grid — 3 tiles (بنزين، الساحبة، الطوارئ).
///
/// Tiles come from the backend (`/home` → banners with type 'service':
/// title + image + action, admin-managed). When the backend hasn't
/// provided any yet, 3 built-in tiles with bundled images are shown.
class ServicesGrid extends StatelessWidget {
  /// Banners of type 'service' from the backend.
  final List<BannerEntity> services;
  final void Function(String route) onNavigate;

  const ServicesGrid({
    super.key,
    required this.services,
    required this.onNavigate,
  });

  /// Maps a backend `action` to an app route.
  static String? routeForAction(String? action) {
    switch (action) {
      case 'fuel':
        return Routes.fuelType;
      case 'towing':
        return Routes.towingRequest;
      case 'emergency':
        // Emergency = ran out of fuel on the road → fuel order flow
        return Routes.fuelType;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final tiles = services.isNotEmpty
        ? [
            for (final s in services)
              _ServiceTileData(
                // Backend titles are Arabic-only; use the app's localized
                // label for known actions so language switching works.
                title: _titleForAction(s.action, l10n) ?? s.title,
                // Known services use the bundled artwork (design refresh);
                // unknown actions still load the backend image.
                imageUrl:
                    _assetForAction(s.action) == null ? s.imageUrl : null,
                imageAsset: _assetForAction(s.action),
                fallbackIcon: _iconForAction(s.action),
                iconColor: _iconColorForAction(s.action),
                route: routeForAction(s.action) ?? Routes.fuelType,
              ),
          ]
        : [
            // Fallback when the backend hasn't seeded service tiles yet.
            // Reuse the *ForAction helpers so styling policy lives in one place.
            _ServiceTileData(
              title: l10n.petrol,
              imageAsset: _assetForAction('fuel'),
              fallbackIcon: Icons.local_gas_station_rounded,
              iconColor: _iconColorForAction('fuel'),
              route: Routes.fuelType,
            ),
            _ServiceTileData(
              title: l10n.searchTowing,
              imageAsset: _assetForAction('towing'),
              fallbackIcon: Icons.fire_truck_outlined,
              iconColor: _iconColorForAction('towing'),
              route: Routes.towingRequest,
            ),
            _ServiceTileData(
              title: l10n.emergencyService,
              imageAsset: _assetForAction('emergency'),
              fallbackIcon: Icons.sos_rounded,
              iconColor: _iconColorForAction('emergency'),
              route: Routes.fuelType,
            ),
          ];

    // Three tiles across the row, each Expanded to a phone-friendly width.
    return SizedBox(
      height: 140.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) SizedBox(width: Insets.s10),
            Expanded(
              child: _ServiceTile(data: tiles[i], onNavigate: onNavigate),
            ),
          ],
        ],
      ),
    );
  }

  static IconData _iconForAction(String? action) {
    switch (action) {
      case 'towing':
        // fire_truck was a fire engine — semantically wrong for towing.
        return Icons.local_shipping_rounded;
      case 'emergency':
        return Icons.emergency_rounded;
      default:
        return Icons.local_gas_station_rounded;
    }
  }

  static Color? _iconColorForAction(String? action) {
    switch (action) {
      case 'fuel':
      case 'towing':
        return AppColors.primary;
      case 'emergency':
        // Warm coral so emergency reads as urgent, distinct from fuel/tow.
        return const Color(0xFFEF6B6B);
      default:
        return null;
    }
  }

  /// Bundled full-color artwork per service (design refresh, 2025-08).
  static String? _assetForAction(String? action) {
    switch (action) {
      case 'fuel':
        return 'assets/images/fuel_tanker.png';
      case 'towing':
        return 'assets/images/tow_truck.png';
      case 'emergency':
        return 'assets/images/emergency_fuel.png';
      default:
        return null;
    }
  }

  static String? _titleForAction(String? action, S l10n) {
    switch (action) {
      case 'fuel':
        return l10n.petrol;
      case 'towing':
        return l10n.searchTowing;
      case 'emergency':
        return l10n.emergencyService;
      default:
        return null;
    }
  }
}

class _ServiceTileData {
  final String title;
  final String? imageUrl; // network (from backend)
  final String? imageAsset; // bundled artwork
  final IconData fallbackIcon;
  final Color? iconColor; // splash + fallback-icon tint
  final String route;

  const _ServiceTileData({
    required this.title,
    this.imageUrl,
    this.imageAsset,
    required this.fallbackIcon,
    this.iconColor,
    required this.route,
  });
}

class _ServiceTile extends StatelessWidget {
  final _ServiceTileData data;
  final void Function(String route) onNavigate;
  const _ServiceTile({required this.data, required this.onNavigate});

  Widget _image(BuildContext context) {
    final tint = data.iconColor;
    final fallback = Icon(
      data.fallbackIcon,
      size: 34.sp,
      color: tint ?? context.colors.primary,
    );
    // Tint applies to flat SVG icons only — raster artwork (photos /
    // illustrations) always renders in its natural colors.
    final svgFilter =
        tint != null ? ColorFilter.mode(tint, BlendMode.srcIn) : null;

    final url = data.imageUrl;
    if (url != null && url.startsWith('http')) {
      if (url.toLowerCase().endsWith('.svg')) {
        return SvgPicture.network(
          url,
          fit: BoxFit.contain,
          colorFilter: svgFilter,
          placeholderBuilder: (_) => fallback,
          // Without this, a failed fetch (server down / no network) throws an
          // unhandled async exception instead of degrading to the icon.
          errorBuilder: (_, __, ___) => fallback,
        );
      }
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
        placeholder: (_, __) => Center(
          child: SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: (tint ?? context.colors.primary).withValues(alpha: 0.5),
            ),
          ),
        ),
        errorWidget: (_, __, ___) => fallback,
      );
    }
    final asset = data.imageAsset;
    if (asset != null) {
      if (asset.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(
          asset,
          fit: BoxFit.contain,
          colorFilter: svgFilter,
        );
      }
      return Image.asset(
        asset,
        fit: BoxFit.contain,
        // The bundled artwork is multi-MP; decode at display size.
        cacheWidth: 220,
        errorBuilder: (_, __, ___) => fallback,
      );
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final splashTint = data.iconColor ?? context.colors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(data.route),
        borderRadius: BorderRadius.circular(AppRadius.s20),
        splashColor: splashTint.withValues(alpha: 0.12),
        highlightColor: splashTint.withValues(alpha: 0.06),
        child: Ink(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            // Single container — soft top-to-bottom gradient over the design
            // grays, with a slightly darker border so the edge reads clearly.
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF7F8FA), Color(0xFFE6E8EB)],
            ),
            border: Border.all(color: const Color(0xFFDDE0E4)),
            borderRadius: BorderRadius.circular(AppRadius.s20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Portrait artwork area — taller than wide per design.
                SizedBox(
                  width: 56.w,
                  height: 72.h,
                  child: _image(context),
                ),
                SizedBox(height: Insets.s10),
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                      color: context.colors.textPrimary,
                      fontSize: FontSize.s14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
