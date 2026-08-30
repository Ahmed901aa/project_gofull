import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/routes/start_route.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 3-screen intro shown once, before login, on a fresh install.
///
/// Full-bleed photography: each page's photo fills the screen with a deep
/// green scrim rising from the bottom so the white copy stays readable
/// (WCAG-safe over any photo). Direction-aware with zero special-casing:
/// PageView, dots and buttons all follow the ambient [Directionality].
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pageCount = 3;

  // Scrim anchor — deep green-black so the fade feels branded, not sooty.
  static const _scrimColor = Color(0xFF00140F);

  bool get _isLast => _page == _pageCount - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Persist "seen" and move on to login. Used by Skip, and by the button
  /// on the last page. Marking on skip too is deliberate: skipping is a
  /// choice, not a reason to replay the intro forever.
  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingSeenKey, true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final pages = [
      _PageData(
        asset: 'assets/images/onboarding_fuel.jpg',
        title: l10n.onbFuelTitle,
        body: l10n.onbFuelBody,
      ),
      _PageData(
        asset: 'assets/images/onboarding_towing.jpg',
        title: l10n.onbTowingTitle,
        body: l10n.onbTowingBody,
      ),
      _PageData(
        asset: 'assets/images/onboarding_tracking.jpg',
        title: l10n.onbTrackingTitle,
        body: l10n.onbTrackingBody,
        // Shift the crop toward the broken-down car on the right of the
        // photo so the "why you need tracking" story stays in frame.
        imageAlignment: const Alignment(0.3, 0),
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // White status-bar icons over the photos.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _scrimColor,
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _OnboardingPage(
                data: pages[i],
                scrimColor: _scrimColor,
              ),
            ),
            // Controls overlay — shared across pages so dots/buttons don't
            // slide with the photos.
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s24),
                child: Column(
                  children: [
                    // Skip — glass pill, top end (left in Arabic).
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: Insets.s8),
                        child: Material(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(AppRadius.s20),
                          child: InkWell(
                            onTap: _finish,
                            borderRadius: BorderRadius.circular(AppRadius.s20),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              child: Text(
                                l10n.skip,
                                style: getMediumStyle(
                                    color: AppColors.white,
                                    fontSize: FontSize.s14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Dots — gold active pill over the scrim.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _pageCount; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOut,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: i == _page ? 26.w : 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: i == _page
                                  ? AppColors.gold
                                  : Colors.white.withValues(alpha: 0.38),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s8),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: Sizes.s20),
                    // Primary action — gold so it pops over the dark scrim.
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: FilledButton(
                        onPressed: _next,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.s16),
                          ),
                        ),
                        child: Text(
                          _isLast ? l10n.getStartedBtn : l10n.nextBtn,
                          style: getBoldStyle(
                              color: AppColors.primaryDark,
                              fontSize: FontSize.s16),
                        ),
                      ),
                    ),
                    SizedBox(height: Sizes.s16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  final String asset;
  final String title;
  final String body;

  /// Where the cover-crop anchors when the photo is wider than the
  /// screen. Center by default; pages can shift toward their subject.
  final Alignment imageAlignment;
  const _PageData({
    required this.asset,
    required this.title,
    required this.body,
    this.imageAlignment = Alignment.center,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _PageData data;
  final Color scrimColor;
  const _OnboardingPage({required this.data, required this.scrimColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Full-bleed photo. Square source, portrait screen: cover-crop keeps
        // the (centered) subject. Not mirrored in RTL — these are scenes,
        // not directional UI icons.
        Image.asset(
          data.asset,
          fit: BoxFit.cover,
          alignment: data.imageAlignment,
          // Decode near display size instead of the full 1200–2048px source.
          cacheHeight: 1400,
        ),
        // Legibility scrims: strong rise from the bottom for the copy and
        // controls, faint wash at the top for the status bar and Skip.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.18, 0.52, 1.0],
              colors: [
                scrimColor.withValues(alpha: 0.45),
                scrimColor.withValues(alpha: 0.0),
                scrimColor.withValues(alpha: 0.0),
                scrimColor.withValues(alpha: 0.92),
              ],
            ),
          ),
        ),
        // Copy — pinned above the shared dots/button overlay.
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: Insets.s24,
                end: Insets.s24,
                // Clears the overlay: dots + button + their spacing.
                bottom: 132.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: getBoldStyle(
                        color: AppColors.white, fontSize: FontSize.s24),
                  ),
                  SizedBox(height: Sizes.s12),
                  Text(
                    data.body,
                    style: getRegularStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: FontSize.s15)
                        .copyWith(height: 1.55),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
