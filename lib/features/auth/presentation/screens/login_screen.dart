import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_event.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_state.dart';
import 'package:project_gofull/features/auth/presentation/widgets/login_form_card.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    if (phone.isEmpty || phone.length < 9) return;
    if (password.isEmpty || password.length < 6) return;
    context.read<AuthBloc>().add(
          LoginRequested(phone: phone, password: password),
        );
  }

  void _navigateAfterAuth(UserEntity user) {
    final route = user.isProvider ? Routes.driverHome : Routes.home;
    Navigator.of(context).pushNamedAndRemoveUntil(route, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _navigateAfterAuth(state.user);
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: context.colors.primary,
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SafeArea(
                    bottom: false,
                    child: Center(
                      child: SvgPicture.asset(
                        SvgAssets.logo,
                        width: 140.w,
                        colorFilter: const ColorFilter.mode(
                            AppColors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.s32)),
                    ),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) => LoginFormCard(
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        errorMessage:
                            state is AuthFailure ? state.message : null,
                        isLoading: state is AuthLoading,
                        onLogin: () => _onLogin(context),
                        onCreateAccount: () {
                          Navigator.of(context).pushNamed(Routes.register);
                        },
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
