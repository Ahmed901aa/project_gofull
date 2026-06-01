import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/auth/presentation/widgets/phone_input_field.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class LoginFormCard extends StatefulWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String? errorMessage;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;

  const LoginFormCard({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.errorMessage,
    required this.onLogin,
    required this.onCreateAccount,
    this.isLoading = false,
  });

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.symmetric(horizontal: Insets.s24, vertical: Insets.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.of(context).login,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s24)),
          SizedBox(height: Sizes.s8),
          Text(S.of(context).loginSubtitle,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                  color: context.colors.iconSecondary, fontSize: FontSize.s14)),
          SizedBox(height: Sizes.s8),
          _buildCreateAccountRow(),
          SizedBox(height: Sizes.s24),

          // ── Phone ──────────────────────────────────────────
          Text(S.of(context).phoneLabel,
              style: getMediumStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16)),
          SizedBox(height: Sizes.s8),
          PhoneInputField(
              controller: widget.phoneController, errorText: null),
          SizedBox(height: Sizes.s16),

          // ── Password ───────────────────────────────────────
          Text(S.of(context).passwordLabel,
              style: getMediumStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16)),
          SizedBox(height: Sizes.s8),
          _buildPasswordField(),

          // ── Error ──────────────────────────────────────────
          if (widget.errorMessage != null) ...[
            SizedBox(height: Sizes.s12),
            Text(
              widget.errorMessage!,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                  color: context.colors.error, fontSize: FontSize.s14),
            ),
          ],

          SizedBox(height: Sizes.s24),
          AppButton(
            text: S.of(context).loginButton,
            isLoading: widget.isLoading,
            onPressed: widget.onLogin,
          ),
          SizedBox(height: Sizes.s24),
          Text(S.of(context).termsText,
              textAlign: TextAlign.center,
              style: getRegularStyle(color: context.colors.iconSecondary, fontSize: 11.sp)),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: context.colors.inputBorder),
      ),
      child: TextField(
        controller: widget.passwordController,
        obscureText: _obscurePassword,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.start,
        style: getMediumStyle(color: context.colors.textPrimary, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: S.of(context).passwordHint,
          hintStyle: getRegularStyle(color: context.colors.iconSecondary, fontSize: 16.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: Insets.s12, vertical: Insets.s12),
          prefixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: context.colors.iconSecondary,
              size: 20.sp,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: widget.onCreateAccount,
            child: Text(S.of(context).createAccount,
                style: getSemiBoldStyle(
                    color: context.colors.primary, fontSize: FontSize.s14)),
          ),
          Text(' ${S.of(context).noAccount}',
              style: getRegularStyle(
                  color: context.colors.iconSecondary, fontSize: FontSize.s14)),
        ],
      );
}
