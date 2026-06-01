import 'package:flutter/material.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    _navigate();
  }

  void _navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) {

        return;

      }

      final tokenStorage = sl<TokenStorage>();
      if (tokenStorage.isLoggedIn) {
        final role = tokenStorage.userRole;
        final route =
            (role == 'provider') ? Routes.driverHome : Routes.home;
        Navigator.of(context).pushReplacementNamed(route);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
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
    );
  }
}
