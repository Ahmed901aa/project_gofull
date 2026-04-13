import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/services/noti_service.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/widgets/rating_bottom_sheet.dart';
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
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
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
  bool _ratingShown = false;

  // Separate bloc for the unrated-order check (doesn't interfere with home polling)
  late final RequestBloc _ratingCheckBloc;

  @override
  void initState() {
    super.initState();
    _ratingCheckBloc = sl<RequestBloc>();
    context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
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
      // Order disappeared — it either completed or was cancelled.
      // If we were tracking one, check if it completed and needs rating.
      if (_lastOrderId != null && _lastOrderStatus != null && !_ratingShown) {
        _checkForCompletedUnrated();
      }
      _lastOrderStatus = null;
      _lastOrderId = null;
      return;
    }

    final newStatus = order.status.trim().toLowerCase();
    final orderId = order.id;

    if (newStatus != _lastOrderStatus || orderId != _lastOrderId) {
      final oldStatus = _lastOrderStatus;
      _lastOrderStatus = newStatus;
      _lastOrderId = orderId;

      // Don't notify on first load
      if (oldStatus == null) return;

      // Fire local notification for status change
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
          'body': order.isFuelDelivery
              ? 'جاري تعبئة الوقود'
              : 'جاري سحب السيارة',
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

  /// When the active order disappears from the home endpoint, ask the backend
  /// if there's a completed-unrated order and show the rating sheet.
  void _checkForCompletedUnrated() {
    _ratingCheckBloc.add(const CheckUnratedOrderEvent());
  }

  void _onRatingCheckState(BuildContext context, RequestState state) async {
    if (state is! UnratedOrderFound || _ratingShown) return;

    final order = state.request;
    final prefs = await SharedPreferences.getInstance();
    final dismissed =
        prefs.getBool('rating_dismissed_${order.id}') ?? false;
    if (dismissed) return;

    _ratingShown = true;
    NotiService().showNotification(
      id: order.id,
      title: 'تمت الخدمة بنجاح',
      body: order.isFuelDelivery ? 'تم تعبئة الوقود بنجاح' : 'تم توصيل السيارة بنجاح',
    );

    // Fuel orders use inline rating on fuel_complete_screen — skip bottom sheet
    if (order.isFuelDelivery) {
      _ratingShown = false;
      return;
    }

    // Delay slightly so the user sees the home screen first
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      showRatingBottomSheet(context, order).then((rated) {
        _ratingShown = false;
        if (rated) {
          prefs.remove('active_order_id');
          prefs.remove('completed_in_app');
        } else {
          prefs.setBool('rating_dismissed_${order.id}', true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = sl<TokenStorage>().getUser();
    final userName = (user?['name'] as String?) ?? 'المستخدم';

    return BlocProvider.value(
      value: _ratingCheckBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: _onRatingCheckState,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: BlocConsumer<AppConfigBloc, AppConfigState>(
            listener: _onConfigChanged,
            builder: (context, config) {
              final hasActiveOrder = config.activeOrder != null;
              final banners = config.banners;

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
                        sliver:
                            const SliverToBoxAdapter(child: PromoBanner()),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),
                      if (hasActiveOrder) ...[
                        SliverToBoxAdapter(
                          child: ActiveOrderCard(
                            activeOrder: config.activeOrder,
                            onCancelled: () {
                              context
                                  .read<AppConfigBloc>()
                                  .add(const LoadHomeDataEvent());
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                            child: SizedBox(height: Sizes.s16)),
                      ],
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                        sliver: const SliverToBoxAdapter(
                            child: ServiceCardsSection()),
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
        ),
      ),
    );
  }
}
