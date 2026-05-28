import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

// ── Types ──────────────────────────────────────────────────

enum AppNotificationType { success, error, warning, info }

// ── AppSnackbar ────────────────────────────────────────────

/// Unified snackbar system for the entire app.
/// Usage:
///   AppSnackbar.success(context, 'تمت العملية بنجاح');
///   AppSnackbar.error(context, 'حدث خطأ أثناء الاتصال بالخادم');
///   AppSnackbar.warning(context, 'لديك طلب نشط بالفعل');
///   AppSnackbar.info(context, 'تم نسخ الرقم');
class AppSnackbar {
  const AppSnackbar._();

  // ── Quick helpers ──

  static void success(BuildContext context, String message) =>
      _show(context, message, AppNotificationType.success);

  static void error(BuildContext context, String message) =>
      _show(context, message, AppNotificationType.error);

  static void warning(BuildContext context, String message) =>
      _show(context, message, AppNotificationType.warning);

  static void info(BuildContext context, String message) =>
      _show(context, message, AppNotificationType.info);

  // ── Core ──

  static void _show(
    BuildContext context,
    String message,
    AppNotificationType type, {
    Duration? duration,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.clearSnackBars();

    final config = _configFor(type);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(config.icon, size: 18.sp, color: AppColors.white),
              ),
              SizedBox(width: Insets.s10),
              Expanded(
                child: Text(
                  message,
                  style: getMediumStyle(
                    color: AppColors.white,
                    fontSize: FontSize.s14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        backgroundColor: config.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        margin: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
        padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 10.h),
        duration: duration ?? const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        elevation: 6,
      ),
    );
  }

  static _SnackConfig _configFor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.success:
        return _SnackConfig(AppColors.success, Icons.check_circle_rounded);
      case AppNotificationType.error:
        return _SnackConfig(AppColors.error, Icons.error_rounded);
      case AppNotificationType.warning:
        return _SnackConfig(AppColors.warning, Icons.warning_rounded);
      case AppNotificationType.info:
        return _SnackConfig(AppColors.primary, Icons.info_rounded);
    }
  }
}

class _SnackConfig {
  final Color color;
  final IconData icon;
  const _SnackConfig(this.color, this.icon);
}

// ── AppConfirmDialog ───────────────────────────────────────

/// Unified confirmation dialog — replaces the scattered AlertDialogs and
/// the existing ConfirmationDialog widget.
///
/// Usage:
///   final confirmed = await AppConfirmDialog.show(
///     context,
///     icon: Icons.cancel_rounded,
///     iconColor: AppColors.error,
///     title: 'إلغاء الطلب',
///     subtitle: 'هل أنت متأكد من إلغاء هذا الطلب؟\nسيتم إبلاغ العميل بالإلغاء.',
///     confirmLabel: 'إلغاء الطلب',
///   );
///   if (confirmed) { /* do it */ }
class AppConfirmDialog {
  const AppConfirmDialog._();

  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    Color iconColor = AppColors.primary,
    required String title,
    required String subtitle,
    required String confirmLabel,
    String? cancelLabel,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ConfirmDialogContent(
        icon: icon,
        iconColor: iconColor,
        title: title,
        subtitle: subtitle,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        destructive: destructive,
      ),
    );
    return result == true;
  }
}

class _ConfirmDialogContent extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final String? cancelLabel;
  final bool destructive;

  const _ConfirmDialogContent({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    this.cancelLabel,
    required this.destructive,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedCancelLabel = cancelLabel ?? S.of(context).goBack;
    final confirmColor = destructive ? AppColors.error : AppColors.primary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: Insets.s24),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: Insets.s20, vertical: 20.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s24),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon circle
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36.sp, color: iconColor),
              ),
              SizedBox(height: 12.h),

              // Title
              Text(
                title,
                style: getBoldStyle(
                  color: const Color(0xFF0E0E0E),
                  fontSize: FontSize.s20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),

              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  subtitle,
                  style: getRegularStyle(
                    color: AppColors.neutral900,
                    fontSize: FontSize.s14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),

              // Buttons
              Row(
                children: [
                  // Cancel (outline)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: AppColors.neutral400,
                          borderRadius: BorderRadius.circular(AppRadius.s16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          resolvedCancelLabel,
                          style: getSemiBoldStyle(
                            color: AppColors.darkGrey,
                            fontSize: FontSize.s15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Insets.s12),
                  // Confirm
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: confirmColor,
                          borderRadius: BorderRadius.circular(AppRadius.s16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          confirmLabel,
                          style: getSemiBoldStyle(
                            color: AppColors.white,
                            fontSize: FontSize.s15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
