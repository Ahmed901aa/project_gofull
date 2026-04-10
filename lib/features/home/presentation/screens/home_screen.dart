import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/services/noti_service.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  Timer? _refreshTimer;
  String? _lastOrderStatus;
  int? _lastOrderId;

  @override
  void initState() {
    super.initState();
    // Load home data (banners + active order) from backend
    context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
    // Poll every 5s so active order status updates + notifications fire
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _onConfigChanged(BuildContext context, AppConfigState config) {
    final order = config.activeOrder;
    if (order == null) {
      // Order finished or doesn't exist — reset tracking
      if (_lastOrderStatus != null && _lastOrderId != null) {
        // The order just disappeared (completed or cancelled)
        _lastOrderStatus = null;
        _lastOrderId = null;
      }
      return;
    }

    final newStatus = order.status.trim().toLowerCase();
    final orderId = order.id;

    // Only fire notification when status actually CHANGES
    if (newStatus != _lastOrderStatus || orderId != _lastOrderId) {
      final oldStatus = _lastOrderStatus;
      _lastOrderStatus = newStatus;
      _lastOrderId = orderId;

      // Don't notify on the first load (oldStatus == null means first time seeing it)
      if (oldStatus == null) return;

      // Fire notification for the new status
      final messages = <String, Map<String, String>>{
        'accepted': {
          'title': 'تم قبول طلبك',
          'body': 'مزود الخدمة وافق على طلبك وسيتحرك إليك قريباً',
        },
        'en_route': {
          'title': 'مزود الخدمة في الطريق',
          'body': 'مزود الخدمة تحرك إلى موقعك',
        },
        'arrived': {
          'title': 'مزود الخدمة وصل',
          'body': 'مزود الخدمة وصل إلى موقعك',
        },
        'in_progress': {
          'title': 'بدأت الخدمة',
          'body': order.isFuelDelivery ? 'جاري تعبئة الوقود' : 'جاري سحب السيارة',
        },
        'completed': {
          'title': 'تمت الخدمة بنجاح',
          'body': order.isFuelDelivery ? 'تم تعبئة الوقود بنجاح' : 'تم توصيل السيارة بنجاح',
        },
      };

      final msg = messages[newStatus];
      if (msg != null) {
        NotiService().showNotification(
          id: orderId,
          title: msg['title']!,
          body: msg['body']!,
        );
      }
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

