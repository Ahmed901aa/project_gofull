import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/auth/presentation/widgets/phone_input_field.dart';

class LoginFormCard extends StatelessWidget {
  final TextEditingController phoneController;
  final String? phoneError;
  final bool isLoading;
  final VoidCallback onSendOtp;

  const LoginFormCard({
    super.key,
    required this.phoneController,
    required this.phoneError,
    required this.onSendOtp,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Insets.s24, vertical: Insets.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppStrings.login,
              textAlign: TextAlign.center,
              style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s24)),
          SizedBox(height: Sizes.s8),
          Text(AppStrings.loginSubtitle,
              textAlign: TextAlign.center,
              style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
          SizedBox(height: Sizes.s8),
          _buildCreateAccountRow(),
          SizedBox(height: Sizes.s32),
          Text(AppStrings.phoneLabel,
              style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s16)),
          SizedBox(height: Sizes.s8),
          PhoneInputField(controller: phoneController, errorText: phoneError),
          SizedBox(height: Sizes.s32),
          AppButton(
            text: AppStrings.sendOtp,
            isLoading: isLoading,
            onPressed: onSendOtp,
          ),
          SizedBox(height: Sizes.s24),
          Text(AppStrings.termsText,
              textAlign: TextAlign.center,
              style: getRegularStyle(color: AppColors.grey, fontSize: 11.sp)),
        ],
      ),
    );
  }

  Widget _buildCreateAccountRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: Text(AppStrings.createAccount,
                style: getSemiBoldStyle(
                    color: AppColors.primary, fontSize: FontSize.s14)),
          ),
          Text(' ${AppStrings.noAccount}',
              style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
        ],
      );
}
