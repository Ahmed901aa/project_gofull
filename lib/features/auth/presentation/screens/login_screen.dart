import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_event.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_state.dart';
import 'package:project_gofull/features/auth/presentation/widgets/login_form_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp(BuildContext context) {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 9) return;
    context.read<AuthBloc>().add(SendOtpRequested('+218$phone'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            Navigator.of(context).pushNamed(
              Routes.otp,
              arguments: OtpArgs(phone: state.phone),
            );
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: AppColors.primary,
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.s32)),
                    ),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) => LoginFormCard(
                        phoneController: _phoneController,
                        phoneError: state is AuthFailure ? state.message : null,
                        isLoading: state is AuthLoading,
                        onSendOtp: () => _onSendOtp(context),
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
