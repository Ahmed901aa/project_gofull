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

class _HomeScreenState extends State<HomeScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Load home data (banners + active order) from backend
    context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
    // Poll every 5s so active order appears when driver accepts
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) context.read<AppConfigBloc>().add(const LoadHomeDataEvent());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = sl<TokenStorage>().getUser();
    final userName = (user?['name'] as String?) ?? 'المستخدم';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: BlocBuilder<AppConfigBloc, AppConfigState>(
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

