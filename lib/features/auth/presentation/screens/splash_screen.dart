import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/utils/startup_log.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/routes/start_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.86, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
    ));
    _footerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
    );
    _controller.forward();
    _navigate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduce-motion: show the finished frame, skip the entrance.
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1.0;
    }
  }

  void _navigate() {
    logStartup('SplashScreen shown — branded pause started');
    // Short branded pause, then route. Wrapped so any unexpected error in
    // session lookup falls back to the login screen instead of leaving the
    // user stuck on the splash forever.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      String route = Routes.login;
      try {
        final tokenStorage = sl<TokenStorage>();
        route = resolveStartRoute(
          isLoggedIn: tokenStorage.isLoggedIn,
          userRole: tokenStorage.userRole,
          onboardingSeen:
              sl<SharedPreferences>().getBool(onboardingSeenKey) ?? false,
        );
      } catch (e) {
        debugPrint('Splash: session check failed, falling back to login: $e');
      }
      if (!mounted) return;
      logStartup('Splash navigating to "$route" — startup complete');
      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Brand screen: committed to the brand palette in both themes, so the
    // launch → splash → app hand-off is seamless (matches the native
    // LaunchScreen.storyboard green).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Warm glow behind the logo so it doesn't float on a void.
                Container(
                  width: 340,
                  height: 340,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.gold.withValues(alpha: 0.14),
                        AppColors.gold.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: SvgPicture.asset(
                      SvgAssets.logo,
                      width: 180,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                // Quiet activity cue during the branded pause.
                PositionedDirectional(
                  bottom: 48,
                  child: FadeTransition(
                    opacity: _footerFade,
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.goldLight.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
