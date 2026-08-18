import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/services/noti_service.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/widgets/rating_bottom_sheet.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_event.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_state.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/home/presentation/widgets/continue_order_card.dart';
import 'package:project_gofull/features/home/presentation/widgets/home_action_cards.dart';
import 'package:project_gofull/features/home/presentation/widgets/home_header.dart';
import 'package:project_gofull/features/home/presentation/widgets/live_prices_section.dart';
import 'package:project_gofull/features/home/presentation/widgets/photo_banners_section.dart';
import 'package:project_gofull/features/home/presentation/widgets/services_grid.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'app_search_screen.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
      // Only check for completed-unrated if the last known status suggests
      // the order actually finished (in_progress / completed). If it was
      // cancelled or still early, skip the check to avoid false positives.
      if (_lastOrderId != null &&
          _lastOrderStatus != null &&
          !_ratingShown &&
          (_lastOrderStatus == 'in_progress' || _lastOrderStatus == 'completed')) {
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
      if (oldStatus == null) {

        return;

      }

      // Don't notify if home isn't the currently visible route —
      // the detail/tracking screen on top handles its own notifications.
      // This prevents duplicate notifications when the user taps
      // "متابعة الطلب" and both screens poll the same status change.
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) {

        return;

      }

      // Fire local notification for status change
      final l10n = S.of(context);
      final messages = <String, Map<String, String>>{
        'accepted': {
          'title': l10n.notifOrderAcceptedTitle,
          'body': l10n.notifOrderAcceptedBody,
        },
        'en_route': {
          'title': l10n.notifProviderEnRouteTitle,
          'body': l10n.notifProviderEnRouteBody,
        },
        'arrived': {
          'title': l10n.notifProviderArrivedTitle,
          'body': l10n.notifProviderArrivedBody,
        },
        'in_progress': {
          'title': l10n.notifServiceStartedTitle,
          'body': order.isFuelDelivery
              ? l10n.notifFuelServiceBody
              : l10n.notifTowServiceBody,
        },
        'cancelled': {
          'title': l10n.notifOrderCancelledTitle,
          'body': l10n.notifOrderCancelledBody,
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

  /// Grid navigation — '_orders' switches the bottom-nav tab, everything
  /// else is a named route.
  void _onGridNavigate(String route) {
    if (route == '_orders') {
      BottomNavShell.shellKey.currentState?.switchTo(1);
      return;
    }
    if (route == '_support') {
      Navigator.pushNamed(context, Routes.support);
      return;
    }
    Navigator.pushNamed(context, route);
  }

  /// When the active order disappears from the home endpoint, ask the backend
  /// if there's a completed-unrated order and show the rating sheet.
  void _checkForCompletedUnrated() {
    _ratingCheckBloc.add(const CheckUnratedOrderEvent());
  }

  void _onRatingCheckState(BuildContext context, RequestState state) async {
    if (state is! UnratedOrderFound || _ratingShown) {

      return;

    }

    final order = state.request;
    final prefs = await SharedPreferences.getInstance();
    final dismissed =
        prefs.getBool('rating_dismissed_${order.id}') ?? false;
    if (dismissed) {

      return;

    }

    if (!context.mounted) {
      return;
    }

    _ratingShown = true;
    final l10n = S.of(context);
    NotiService().showNotification(
      id: order.id,
      title: l10n.notifServiceCompletedTitle,
      body: order.isFuelDelivery ? l10n.notifFuelCompletedBody : l10n.notifTowCompletedBody,
    );

    // Fuel orders use inline rating on fuel_complete_screen — skip bottom sheet
    if (order.isFuelDelivery) {
      _ratingShown = false;
      return;
    }

    // Delay slightly so the user sees the home screen first
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!context.mounted) {

        return;

      }
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
    final userName = (user?['name'] as String?) ?? S.of(context).userDefault;

    return BlocProvider.value(
      value: _ratingCheckBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: _onRatingCheckState,
        child: Scaffold(
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? context.colors.background
                  : Colors.white,
          body: BlocConsumer<AppConfigBloc, AppConfigState>(
            listener: _onConfigChanged,
            builder: (context, config) {
              final banners = config.banners;
              // Service tiles vs photo/promo banners (both admin-managed)
              final serviceTiles =
                  banners.where((b) => b.isService).toList();
              final promoBanners =
                  banners.where((b) => !b.isService).toList();

              return RefreshIndicator(
                color: context.colors.primary,
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
                      // 1. Green header (greeting + bell + search)
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

                      // 2. Services section: green accent bar + title + grid
                      SliverPadding(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
                        sliver: SliverToBoxAdapter(
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
                                S.of(context).homeServicesTitle,
                                style: getBoldStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: FontSize.s16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: Sizes.s8)),
                      SliverPadding(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
                        sliver: SliverToBoxAdapter(
                          child: ServicesGrid(
                            services: serviceTiles,
                            onNavigate: _onGridNavigate,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),

                      // 3. Live admin-controlled data: today's fuel prices
                      //    + open stations counter (Reverb `home-data` channel)
                      if (config.fuelPrices.isNotEmpty) ...[
                        SliverPadding(
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: Insets.s16),
                          sliver: SliverToBoxAdapter(
                            child: FuelPricesSection(
                                prices: config.fuelPrices),
                          ),
                        ),
                        SliverToBoxAdapter(
                            child: SizedBox(height: Sizes.s12)),
                      ],
                      SliverPadding(
                        padding: EdgeInsetsDirectional.symmetric(
                            horizontal: Insets.s16),
                        sliver: SliverToBoxAdapter(
                          child: OpenStationsCard(
                              count: config.openStationsCount),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),

                      // 4. Wide action cards: fuel now + tow truck
                      SliverPadding(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
                        sliver: const SliverToBoxAdapter(
                            child: HomeActionCards()),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: Sizes.s20)),

                      // 4. Continue Order card — shown whenever there's an
                      //    active order. Hidden otherwise.
                      if (config.activeOrder != null) ...[
                        SliverToBoxAdapter(
                          child: ContinueOrderCard(
                            order: config.activeOrder!,
                            onCancelled: () {
                              context
                                  .read<AppConfigBloc>()
                                  .add(const LoadHomeDataEvent());
                            },
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: Sizes.s20)),
                      ],


                      // 5. Photo banners from the backend (stations/promos).
                      //    Falls back to bundled station photos when empty.
                      SliverPadding(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
                        sliver: SliverToBoxAdapter(
                            child: PhotoBannersSection(banners: promoBanners)),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: Sizes.s24)),
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
