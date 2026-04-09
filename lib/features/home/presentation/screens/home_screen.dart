import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';
import 'package:project_gofull/features/home/presentation/widgets/active_order_card.dart';
import 'package:project_gofull/features/home/presentation/widgets/home_header.dart';
import 'package:project_gofull/features/home/presentation/widgets/offers_section.dart';
import 'package:project_gofull/features/home/presentation/widgets/offers_shimmer.dart';
import 'package:project_gofull/features/home/presentation/widgets/promo_banner.dart';
import 'package:project_gofull/features/home/presentation/widgets/service_cards_section.dart';
import 'app_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Timer? _refreshTimer;
  String? _lastKnownStatus;
  int? _lastKnownOrderId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load home data (banners + active order) from backend
    context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
    // Poll every 5s so active order appears when driver accepts
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When user returns to the app, refresh immediately
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _onConfigChanged(BuildContext context, AppConfigState config) {
    final active = config.activeOrder;
    if (active == null) {
      _lastKnownStatus = null;
      _lastKnownOrderId = null;
      return;
    }

    final currentStatus = active.status.trim().toLowerCase();

    // Detect a real status change (not first load)
    final isNewOrder = _lastKnownOrderId != null && _lastKnownOrderId != active.id;
    final isStatusChange = _lastKnownOrderId == active.id &&
        _lastKnownStatus != null &&
        _lastKnownStatus != currentStatus;

    if (isStatusChange || isNewOrder) {
      final msg = _arabicStatusMessage(currentStatus, active.isFuelDelivery);
      if (msg != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg, textDirection: TextDirection.rtl),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'عرض',
              textColor: AppColors.white,
              onPressed: () {
                // Re-trigger the home bloc to refresh; card handles resume
                context
                    .read<AppConfigBloc>()
                    .add(const LoadHomeDataEvent());
              },
            ),
          ),
        );
      }
    }

    _lastKnownOrderId = active.id;
    _lastKnownStatus = currentStatus;
  }

  String? _arabicStatusMessage(String status, bool isFuel) {
    switch (status) {
      case 'accepted':
        return isFuel
            ? 'تم قبول طلب الوقود من قبل مزود الخدمة'
            : 'تم قبول طلب الونش من قبل السائق';
      case 'en_route':
        return isFuel
            ? 'مزود الوقود في الطريق إليك'
            : 'سائق الونش في الطريق إليك';
      case 'arrived':
        return 'وصل مزود الخدمة إلى موقعك';
      case 'in_progress':
        return isFuel
            ? 'جاري تعبئة الوقود'
            : 'جاري سحب السيارة إلى الوجهة';
      case 'completed':
        return 'تم إكمال الخدمة بنجاح';
      case 'cancelled':
        return 'تم إلغاء الطلب';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = sl<TokenStorage>().getUser();
    final userName = (user?['name'] as String?) ?? 'المستخدم';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: BlocConsumer<AppConfigBloc, AppConfigState>(
        listener: _onConfigChanged,
        builder: (context, config) {
          final hasActiveOrder = config.activeOrder != null;
          final banners = config.banners;

          // Map banners → OfferEntity-like objects for OffersSection
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context.read<AppConfigBloc>()
                ..add(const LoadAppConfigEvent())
                ..add(const LoadHomeDataEvent());
              await Future.delayed(const Duration(milliseconds: 600));
            },
            child: SafeArea(
              top: false,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeHeader(
                      userName: userName,
                      onSearchTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AppSearchScreen()),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                    sliver: const SliverToBoxAdapter(child: PromoBanner()),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),
                  if (hasActiveOrder) ...[
                    SliverToBoxAdapter(
                      child: ActiveOrderCard(
                        activeOrder: config.activeOrder,
                        onCancelled: () {
                          context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
                        },
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),
                  ],
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                    sliver:
                        const SliverToBoxAdapter(child: ServiceCardsSection()),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),
                  SliverToBoxAdapter(
                    child: banners.isNotEmpty
                        ? OffersSection(
                            offers: banners
                                .map((b) => OfferEntity(
                                      id: b.id.toString(),
                                      title: b.title,
                                      code: b.discountCode ?? '',
                                      colorValue: b.colorValue,
                                    ))
                                .toList(),
                          )
                        : config.isLoading
                            ? const OffersShimmer()
                            : const SizedBox.shrink(),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

