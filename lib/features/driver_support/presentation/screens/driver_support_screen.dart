import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class DriverSupportScreen extends StatelessWidget {
  const DriverSupportScreen({super.key});

  String _getPhone(BuildContext context) {
    try {
      return context.read<AppConfigBloc>().state.supportPhone;
    } catch (_) {
      return '0915909734';
    }
  }

  Future<void> _callSupport(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _copyPhone(BuildContext context, String phone) {
    Clipboard.setData(ClipboardData(text: phone));
    AppSnackbar.info(context, S.of(context).numberCopiedSnack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SupportIllustration(),
                    SizedBox(height: Insets.s24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                      child: Builder(builder: (ctx) {
                        final phone = _getPhone(ctx);
                        return _DirectCallSection(
                          phone: phone,
                          onCall: () => _callSupport(phone),
                          onCopy: () => _copyPhone(ctx, phone),
                        );
                      }),
                    ),
                    SizedBox(height: Insets.s32),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(backArrowIcon(context),
                        size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).technicalSupportTitle,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );
}

// ── Illustration ─────────────────────────────────────────

class _SupportIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SvgPicture.asset(
          SvgAssets.helpUser,
          width: screenWidth,
          fit: BoxFit.cover,
        ),
        SizedBox(height: Insets.s12),
        Text(
          S.of(context).supportTeamAvailable,
          style: getMediumStyle(
              color: context.colors.primary, fontSize: FontSize.s16),
        ),
      ],
    );
  }
}

// ── Direct Call Section ──────────────────────────────────

class _DirectCallSection extends StatelessWidget {
  final String phone;
  final VoidCallback onCall;
  final VoidCallback onCopy;

  const _DirectCallSection({required this.phone, required this.onCall, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.of(context).directCallLabel,
          style: getBoldStyle(
              color: context.colors.textPrimary, fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              // Phone icon
              GestureDetector(
                onTap: onCall,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.phone_rounded,
                      size: 22.sp, color: context.colors.surface),
                ),
              ),
              SizedBox(width: Insets.s12),
              // Label + number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).phoneNumberLabel2,
                      style: getRegularStyle(
                          color: context.colors.iconSecondary, fontSize: FontSize.s12),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      phone,
                      style: getSemiBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s16),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              // Copy icon
              GestureDetector(
                onTap: onCopy,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.copy_rounded,
                      size: 18.sp, color: context.colors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

