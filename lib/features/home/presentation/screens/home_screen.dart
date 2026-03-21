import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_bloc.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_event.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_state.dart';
import 'package:project_gofull/features/home/presentation/widgets/home_header.dart';
import 'package:project_gofull/features/home/presentation/widgets/offers_section.dart';
import 'package:project_gofull/features/home/presentation/widgets/promo_banner.dart';
import 'package:project_gofull/features/home/presentation/widgets/service_cards_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const LoadOffersRequested()),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const HomeHeader(userName: 'أحمد'),
              Expanded(
                child: Container(
                  color: AppColors.scaffoldBg,
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          context
                              .read<HomeBloc>()
                              .add(const LoadOffersRequested());
                          await Future.delayed(
                              const Duration(milliseconds: 600));
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Insets.s16,
                            vertical: Insets.s16,
                          ),
                          children: [
                            // Promo banner
                            const PromoBanner(),
                            SizedBox(height: Sizes.s20),

                            // Services section header
                            Text(
                              'خدماتنا',
                              style: getBoldStyle(
                                color: AppColors.black,
                                fontSize: FontSize.s18,
                              ),
                            ),
                            SizedBox(height: Sizes.s12),
                            const ServiceCardsSection(),
                            SizedBox(height: Sizes.s24),

                            // Offers section header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.offersForYou,
                                  style: getBoldStyle(
                                    color: AppColors.black,
                                    fontSize: FontSize.s18,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // TODO: Navigate to all offers
                                  },
                                  child: Text(
                                    AppStrings.seeAll,
                                    style: getMediumStyle(
                                      color: AppColors.primary,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Sizes.s12),

                            // Offers
                            if (state is HomeLoaded)
                              OffersSection(offers: state.offers)
                            else if (state is HomeLoading)
                              _buildOffersShimmer()
                            else
                              const SizedBox.shrink(),

                            SizedBox(height: Sizes.s24),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOffersShimmer() {
    return SizedBox(
      height: Sizes.s40 * 4,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: Insets.s12),
        itemBuilder: (_, __) => Container(
          width: Sizes.s40 * 5.5,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(Insets.s12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: Sizes.s8),
                      Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
