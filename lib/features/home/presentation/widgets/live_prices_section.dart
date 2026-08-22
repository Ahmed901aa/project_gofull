import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/app_config/domain/entities/fuel_price_entity.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// "Today's Fuel Prices" — live cards fed by the `home-data` Reverb channel.
/// When the admin saves a price in the dashboard, [AppConfigBloc] patches its
/// state and these cards animate to the new value instantly.
class FuelPricesSection extends StatelessWidget {
  final List<FuelPriceEntity> prices;
  const FuelPricesSection({super.key, required this.prices});

  /// Localized display name for a fuel type. Prefers the l10n key; falls
  /// back to the backend Arabic name, then the raw type.
  String _fuelName(BuildContext context, FuelPriceEntity price) {
    final l10n = S.of(context);
    switch (price.fuelType) {
      case 'petrol':
        return l10n.gasoline;
      case 'diesel':
        return l10n.diesel;
      default:
        final isArabic =
            Localizations.localeOf(context).languageCode == 'ar';
        return isArabic ? price.nameAr : price.fuelType;
    }
  }

  IconData _fuelIcon(String fuelType) => fuelType == 'diesel'
      ? Icons.oil_barrel_rounded
      : Icons.local_gas_station_rounded;

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) return const SizedBox.shrink();
    final l10n = S.of(context);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header: green accent bar + title + live chip
        Row(
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
            Expanded(
              child: Text(
                l10n.todaysFuelPrices,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  color: context.colors.textPrimary,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
            const _LiveChip(),
          ],
        ),
        SizedBox(height: Insets.s12),
        // Cards keep the English (LTR) arrangement in both languages —
        // same card positions and icon side regardless of locale.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              for (var i = 0; i < prices.length; i++) ...[
                if (i > 0) SizedBox(width: Insets.s12),
                Expanded(
                  child: _PriceCard(
                    name: _fuelName(context, prices[i]),
                    icon: _fuelIcon(prices[i].fuelType),
                    price: prices[i].priceWithTax,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final double price;

  const _PriceCard({
    required this.name,
    required this.icon,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(Insets.s12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: colors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Icon(icon, size: 17.sp, color: colors.primary),
              ),
              SizedBox(width: Insets.s8),
              // Name pushed to the far edge — maximum distance from the icon.
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: getMediumStyle(
                    color: colors.textSecondary,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.s10),
          // Animates when a live price update lands
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Text(
              price.toStringAsFixed(2),
              key: ValueKey(price),
              style: getBoldStyle(
                color: colors.textPrimary,
                fontSize: FontSize.s20,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '${l10n.currencyDL} ${l10n.perLiter}',
            style: getRegularStyle(
              color: colors.textDisabled,
              fontSize: FontSize.s12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Slim admin-controlled counter: "N stations open now".
/// Updates live over the same Reverb channel.
class OpenStationsCard extends StatelessWidget {
  final int count;
  const OpenStationsCard({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colors = context.colors;
    final isOpen = count > 0;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: Insets.s14, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: isOpen ? colors.successSurface : colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(
          color: (isOpen ? colors.success : colors.border)
              .withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
            ),
            child: Icon(
              Icons.ev_station_rounded,
              size: 18.sp,
              color: isOpen ? colors.success : colors.iconSecondary,
            ),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.35),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                l10n.openStationsNow(count),
                key: ValueKey(count),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  color: colors.textPrimary,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          ),
          if (isOpen) const _PulsingDot(),
        ],
      ),
    );
  }
}

/// Small "Live" chip with a pulsing green dot.
class _LiveChip extends StatelessWidget {
  const _LiveChip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: Insets.s8, vertical: 3.h),
      decoration: BoxDecoration(
        color: colors.successSurface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PulsingDot(),
          SizedBox(width: 5.w),
          Text(
            S.of(context).liveNow,
            style: getMediumStyle(
              color: colors.success,
              fontSize: FontSize.s12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.25, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 7.w,
        height: 7.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.success,
        ),
      ),
    );
  }
}
