import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
  static const Duration _interval = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(_interval, (_) {
      final next = (_currentPage + 1) % _totalPages;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
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
              itemBuilder: (_, __) => _buildBannerCard(),
            ),
          ),
        ),
        SizedBox(height: Insets.s12),
        _buildDots(),
      ],
    );
  }

  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.95, 0.35),
          end: Alignment(0.95, -0.35),
          colors: [
            Color(0xFFFFB800),
            Color(0xFFE1A200),
            Color(0xFF996E00),
          ],
          stops: [0.048, 0.307, 1.0],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative circle 1 — lighter gold, behind truck
          Positioned(
            right: -10.w,
            top: 8.h,
            child: Container(
              width: 108.w,
              height: 124.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFCF40).withValues(alpha: 0.4),
              ),
            ),
          ),

          // Decorative circle 2 — darker gold, same position
          Positioned(
            right: -10.w,
            top: 8.h,
            child: Container(
              width: 108.w,
              height: 124.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB88A00).withValues(alpha: 0.25),
              ),
            ),
          ),

          // Truck image — RIGHT side, overflows top & bottom
          Positioned(
            right: -10.w,
            top: -5.h,
            bottom: -5.h,
            width: 140.w,
            child: Image.asset(
              ImageAssets.promoTruck,
              fit: BoxFit.contain,
            ),
          ),

          // Text content — LEFT side
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s12, 0, 140.w, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    textDirection: TextDirection.rtl,
                    text: TextSpan(
                      style: getBoldStyle(
                        color: const Color(0xFF0E0E0E),
                        fontSize: FontSize.s16,
                      ),
                      children: const [
                        TextSpan(text: 'جميع  خدمات الطوارئ في '),
                        TextSpan(
                          text: 'اشتراك واحد',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Insets.s8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.s12,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.s24),
                    ),
                    child: Text(
                      'قسائم مجانية + خصومات حصرية',
                      style: getMediumStyle(
                        color: AppColors.primary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPages, (i) {
        final isActive = i == _currentPage;
        return Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 2.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 8.w : 5.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.primary200,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      }),
    );
  }
}
