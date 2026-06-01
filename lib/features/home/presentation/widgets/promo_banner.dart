import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'promo_banner_card.dart';
import 'promo_dots_indicator.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  static const int _totalPages = 3;
  static const Duration _interval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoplay();
  }

  void _startAutoplay() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % _totalPages;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Card with soft shadow
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.s32),
            boxShadow: [
              BoxShadow(
                color: context.colors.primary.withValues(alpha: 0.20),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s32),
            child: SizedBox(
              height: 170.h,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => PromoBannerCard(index: i),
              ),
            ),
          ),
        ),
        SizedBox(height: Insets.s12),
        PromoDotsIndicator(
          totalPages: _totalPages,
          currentPage: _currentPage,
          activeColor: context.colors.primary,
        ),
      ],
    );
  }
}
