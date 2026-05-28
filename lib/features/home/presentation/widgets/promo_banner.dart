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
  late final Timer _timer;
  int _currentPage = 0;

  static const int _totalPages = 3;
  static const Duration _interval = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(_interval, (_) {
      final next = (_currentPage + 1) % _totalPages;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.s16),
          child: SizedBox(
            height: 140.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalPages,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => PromoBannerCard(index: i),
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
