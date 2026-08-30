import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/routes/start_route.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 3-screen intro shown once, before login, on a fresh install.
///
/// Fully direction-aware with zero special-casing: PageView, dots and
/// buttons all follow the ambient [Directionality], so Arabic swipes
/// right-to-left and English left-to-right.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pageCount = 3;

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
    final colors = context.colors;

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
      ),
    ];

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip — top end (left in Arabic, right in English).
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                    end: Insets.s8, top: Insets.s4),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    l10n.skip,
                    style: getMediumStyle(
                        color: colors.textSecondary, fontSize: FontSize.s14),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _OnboardingPage(data: pages[i]),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pageCount; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: i == _page ? 24.w : 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: i == _page ? colors.primary : colors.border,
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s24, Sizes.s24, Insets.s24, Sizes.s16),
              child: AppButton(
                text: _isLast ? l10n.getStartedBtn : l10n.nextBtn,
                onPressed: _next,
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
  const _PageData({
    required this.asset,
    required this.title,
    required this.body,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _PageData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decorative scene art — not directional UI icons, so it is not
          // mirrored in RTL. Raster photos get a rounded card treatment;
          // SVG placeholders render as-is.
          data.asset.toLowerCase().endsWith('.svg')
              ? SvgPicture.asset(data.asset, width: 0.72.sw)
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.s24),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.s24),
                    child: Image.asset(
                      data.asset,
                      width: 0.78.sw,
                      height: 0.78.sw,
                      fit: BoxFit.cover,
                      // Bundled photos are larger than display size.
                      cacheWidth: 1000,
                    ),
                  ),
                ),
          SizedBox(height: Sizes.s32),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
                color: colors.textPrimary, fontSize: FontSize.s22),
          ),
          SizedBox(height: Sizes.s12),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: getRegularStyle(
                color: colors.textSecondary, fontSize: FontSize.s15),
          ),
        ],
      ),
    );
  }
}
