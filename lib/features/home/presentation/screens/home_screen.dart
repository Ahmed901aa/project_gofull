import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_bloc.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_event.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_state.dart';
import 'package:project_gofull/features/home/presentation/widgets/active_order_card.dart';
import 'package:project_gofull/features/home/presentation/widgets/home_header.dart';
import 'package:project_gofull/features/home/presentation/widgets/offers_section.dart';
import 'package:project_gofull/features/home/presentation/widgets/promo_banner.dart';
import 'package:project_gofull/features/home/presentation/widgets/service_cards_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Toggle to show/hide active order card (BLoC can drive this later)
  static const bool _hasActiveOrder = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const LoadOffersRequested()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context.read<HomeBloc>().add(const LoadOffersRequested());
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: SafeArea(
                top: false,
                child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // Header — edge-to-edge, no padding
                  SliverToBoxAdapter(
                    child: const HomeHeader(userName: 'أحمد'),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),

                  // Promo banner
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                    sliver: const SliverToBoxAdapter(child: PromoBanner()),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),

                  // Active order card (conditional)
                  if (_hasActiveOrder) ...[
                    const SliverToBoxAdapter(child: ActiveOrderCard()),
                    SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),
                  ],

                  // Service cards
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                    sliver: const SliverToBoxAdapter(child: ServiceCardsSection()),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: Sizes.s16)),

                  // Offers section
                  SliverToBoxAdapter(
                    child: state is HomeLoaded
                        ? OffersSection(offers: state.offers)
                        : state is HomeLoading
                            ? _buildOffersShimmer()
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
    );
  }

  Widget _buildOffersShimmer() {
    return SizedBox(
      height: Sizes.s40 * 4,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Insets.s16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: Insets.s12),
        itemBuilder: (_, __) => Container(
          width: 220.w,
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
        ),
      ),
    );
  }
}
