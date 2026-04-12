import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_event.dart';
import 'package:project_gofull/features/auth/presentation/bloc/auth_state.dart';
import 'package:project_gofull/features/auth/presentation/widgets/phone_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final String _selectedRole = 'driver';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty) return;
    if (phone.isEmpty || phone.length < 9) return;
    if (password.isEmpty || password.length < 6) return;
    if (password != confirm) return;

    context.read<AuthBloc>().add(RegisterRequested(
          name: name,
          phone: phone,
          password: password,
          passwordConfirmation: confirm,
          role: _selectedRole,
        ));
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
            backgroundColor: AppColors.primary,
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SafeArea(
                    bottom: false,
                    child: Center(
                      child: SvgPicture.asset(
                        SvgAssets.logo,
                        width: 100.w,
                        colorFilter: const ColorFilter.mode(
                            AppColors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.s32)),
                    ),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) => _buildForm(context, state),
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

  Widget _buildForm(BuildContext context, AuthState state) {
    final isLoading = state is AuthLoading;
    final errorMsg = state is AuthFailure ? state.message : null;

    return SingleChildScrollView(
      padding:
          EdgeInsets.symmetric(horizontal: Insets.s24, vertical: Insets.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppStrings.createAccountTitle,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                  color: AppColors.black, fontSize: FontSize.s24)),
          SizedBox(height: Sizes.s8),
          _buildLoginRow(),
          SizedBox(height: Sizes.s20),

          // ── Name ───────────────────────────────────────────
          Text(AppStrings.nameLabel,
              style: getMediumStyle(
                  color: AppColors.black, fontSize: FontSize.s16)),
          SizedBox(height: Sizes.s8),
          _buildTextField(
            controller: _nameController,
            hint: AppStrings.nameHint,
          ),
          SizedBox(height: Sizes.s16),

          // ── Phone ──────────────────────────────────────────
          Text(AppStrings.phoneLabel,
              style: getMediumStyle(
                  color: AppColors.black, fontSize: FontSize.s16)),
          SizedBox(height: Sizes.s8),
          PhoneInputField(controller: _phoneController, errorText: null),
          SizedBox(height: Sizes.s16),

          // ── Password ───────────────────────────────────────
          Text(AppStrings.passwordLabel,
              style: getMediumStyle(
                  color: AppColors.black, fontSize: FontSize.s16)),
          SizedBox(height: Sizes.s8),
          _buildPasswordField(
            controller: _passwordController,
            hint: AppStrings.passwordHint,
            obscure: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          SizedBox(height: Sizes.s16),

          // ── Confirm Password ───────────────────────────────
          Text(AppStrings.confirmPasswordLabel,
              style: getMediumStyle(
                  color: AppColors.black, fontSize: FontSize.s16)),
          SizedBox(height: Sizes.s8),
          _buildPasswordField(
            controller: _confirmPasswordController,
            hint: AppStrings.confirmPasswordHint,
            obscure: _obscureConfirm,
            onToggle: () =>
                setState(() => _obscureConfirm = !_obscureConfirm),
          ),

          // ── Error ──────────────────────────────────────────
          if (errorMsg != null) ...[
            SizedBox(height: Sizes.s12),
            Text(errorMsg,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                    color: AppColors.error, fontSize: FontSize.s14)),
          ],

          SizedBox(height: Sizes.s24),
          AppButton(
            text: AppStrings.registerButton,
            isLoading: isLoading,
            onPressed: () => _onRegister(context),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        style: getMediumStyle(color: AppColors.black, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: getRegularStyle(color: AppColors.grey, fontSize: 16.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: Insets.s12, vertical: Insets.s12),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        style: getMediumStyle(color: AppColors.black, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: getRegularStyle(color: AppColors.grey, fontSize: 16.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: Insets.s12, vertical: Insets.s12),
          prefixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.grey,
              size: 20.sp,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Text(AppStrings.loginButton,
                style: getSemiBoldStyle(
                    color: AppColors.primary, fontSize: FontSize.s14)),
          ),
          Text(' ${AppStrings.alreadyHaveAccount}',
              style: getRegularStyle(
                  color: AppColors.grey, fontSize: FontSize.s14)),
        ],
      );
}
