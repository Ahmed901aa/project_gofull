import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
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
                title: s.title,
                imageUrl: s.imageUrl,
                fallbackIcon: _iconForAction(s.action),
                route: routeForAction(s.action) ?? Routes.fuelType,
              ),
          ]
        : [
            // Fallback when the backend hasn't seeded service tiles yet
            _ServiceTileData(
              title: l10n.petrol,
              imageAsset: 'assets/icons/Frame 1984080696.svg',
              fallbackIcon: Icons.local_gas_station_rounded,
              route: Routes.fuelType,
            ),
            _ServiceTileData(
              title: l10n.searchTowing,
              imageAsset: 'assets/svg/towing.svg',
              fallbackIcon: Icons.fire_truck_outlined,
              route: Routes.towingRequest,
            ),
            _ServiceTileData(
              title: l10n.emergencyService,
              imageAsset: 'assets/images/fuel_jerrycan.png',
              fallbackIcon: Icons.sos_rounded,
              route: Routes.fuelType,
            ),
          ];

    // IntrinsicHeight bounds the Row's height so `stretch` can equalize
    // tile heights (stretch inside an unbounded sliver context would
    // otherwise force infinite height and crash layout/semantics).
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) SizedBox(width: Insets.s10),
            Expanded(
                child: _ServiceTile(data: tiles[i], onNavigate: onNavigate)),
          ],
        ],
      ),
    );
  }

  static IconData _iconForAction(String? action) {
    switch (action) {
      case 'towing':
        return Icons.fire_truck_outlined;
      case 'emergency':
        return Icons.sos_rounded;
      default:
        return Icons.local_gas_station_rounded;
    }
  }
}

class _ServiceTileData {
  final String title;
  final String? imageUrl; // network (from backend)
  final String? imageAsset; // bundled fallback
  final IconData fallbackIcon;
  final String route;

  const _ServiceTileData({
    required this.title,
    this.imageUrl,
    this.imageAsset,
    required this.fallbackIcon,
    required this.route,
  });
}

class _ServiceTile extends StatelessWidget {
  final _ServiceTileData data;
  final void Function(String route) onNavigate;
  const _ServiceTile({required this.data, required this.onNavigate});

  Widget _image(BuildContext context) {
    final fallback = Icon(
      data.fallbackIcon,
      size: 34.sp,
      color: context.colors.primary,
    );

    final url = data.imageUrl;
    if (url != null && url.startsWith('http')) {
      // SVGs (e.g. the towing icon) need flutter_svg — CachedNetworkImage
      // can't decode them.
      if (url.toLowerCase().endsWith('.svg')) {
        return SvgPicture.network(
          url,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => fallback,
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
              color: context.colors.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
        errorWidget: (_, __, ___) => fallback,
      );
    }
    final asset = data.imageAsset;
    if (asset != null) {
      if (asset.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(asset, fit: BoxFit.contain);
      }
      return Image.asset(
        asset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => fallback,
      );
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(data.route),
        borderRadius: BorderRadius.circular(AppRadius.s20),
        splashColor: context.colors.primary.withValues(alpha: 0.10),
        highlightColor: context.colors.primary.withValues(alpha: 0.05),
        child: Ink(
          padding: EdgeInsets.symmetric(
              vertical: Insets.s14, horizontal: Insets.s8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: isDark
                  ? [
                      context.colors.surface,
                      context.colors.surface.withValues(alpha: 0.85),
                    ]
                  : [
                      context.colors.surfaceElevated,
                      context.colors.surface,
                    ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.s20),
            border: Border.all(
              color: isDark
                  ? context.colors.border.withValues(alpha: 0.6)
                  : context.colors.primary.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : context.colors.primary.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image inside a soft tinted square for visual lift
              Container(
                width: 64.w,
                height: 64.w,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                ),
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
    );
  }
}
