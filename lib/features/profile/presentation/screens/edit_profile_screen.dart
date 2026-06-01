import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/services/token_storage.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import '../widgets/edit_profile_avatar.dart';

/// Read-only profile screen.
///
/// Shows the customer's name and phone number as plain display text.
/// No editing, no buttons. Account deletion is intentionally not exposed
/// here — that flow lives elsewhere if/when product needs it.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final user = sl<TokenStorage>().getUser() ?? const {};
    final name = (user['name'] as String?)?.trim();
    final phone = (user['phone'] as String?)?.trim();

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          AppHeader(title: l10n.profileTitle),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.fromSTEB(
                Insets.s16,
                Insets.s24,
                Insets.s16,
                Insets.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const EditProfileAvatar(),
                  SizedBox(height: Sizes.s24),
                  _ReadOnlyField(
                    label: l10n.fullNameLabel,
                    value: name?.isNotEmpty == true ? name! : '—',
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: Sizes.s16),
                  _ReadOnlyField(
                    label: l10n.phoneLabel,
                    value: phone?.isNotEmpty == true ? phone! : '—',
                    icon: Icons.phone_outlined,
                    forceLtr: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  /// Forces the value text to render left-to-right (e.g. phone numbers).
  final bool forceLtr;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
    this.forceLtr = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getSemiBoldStyle(
            color: context.colors.textPrimary,
            fontSize: FontSize.s14,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: Insets.s14,
            vertical: 14.h,
          ),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18.sp, color: context.colors.textSecondary),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  value,
                  textDirection:
                      forceLtr ? TextDirection.ltr : null,
                  textAlign: TextAlign.start,
                  style: getMediumStyle(
                    color: context.colors.textPrimary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
