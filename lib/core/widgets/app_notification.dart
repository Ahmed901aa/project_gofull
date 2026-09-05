import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
    if (messenger == null) {

      return;

    }

    messenger.clearSnackBars();

    final config = _configFor(context, type);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: context.colors.surface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(config.icon, size: 18.sp, color: context.colors.surface),
              ),
              SizedBox(width: Insets.s10),
              Expanded(
                child: Text(
                  message,
                  style: getMediumStyle(
                    color: context.colors.surface,
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

  static _SnackConfig _configFor(BuildContext context, AppNotificationType type) {
    switch (type) {
      case AppNotificationType.success:
        return _SnackConfig(context.colors.success, Icons.check_circle_rounded);
      case AppNotificationType.error:
        return _SnackConfig(context.colors.error, Icons.error_rounded);
      case AppNotificationType.warning:
        return _SnackConfig(context.colors.warning, Icons.warning_rounded);
      case AppNotificationType.info:
        return _SnackConfig(context.colors.primary, Icons.info_rounded);
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
///     iconColor: context.colors.error,
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
    Color? iconColor,
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

  /// Optional override. Left null, the icon takes the confirm action's own
  /// colour so a red button never sits beneath an amber icon.
  final Color? iconColor;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final String? cancelLabel;
  final bool destructive;

  const _ConfirmDialogContent({
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    this.cancelLabel,
    required this.destructive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedCancelLabel = cancelLabel ?? S.of(context).goBack;
    final confirmColor = destructive ? colors.error : colors.primary;
    final resolvedIconColor = iconColor ?? confirmColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: Insets.s24),
      // Cap the width so this stays a dialog on a tablet instead of
      // stretching across the whole screen.
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: Insets.s20, vertical: 24.h),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.s24),
            // The dark theme carries no shadow token, so lean on a hairline
            // there to separate the card from the scrim.
            border: context.isDarkMode
                ? Border.all(color: colors.borderSubtle)
                : null,
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: resolvedIconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 34.sp, color: resolvedIconColor),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: getBoldStyle(
                  color: colors.textPrimary,
                  fontSize: FontSize.s20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                style: getRegularStyle(
                  color: colors.textSecondary,
                  fontSize: FontSize.s14,
                ).copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              _DialogActions(
                cancelLabel: resolvedCancelLabel,
                confirmLabel: confirmLabel,
                confirmColor: confirmColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cancel + confirm, side by side — or stacked when the viewer's text size
/// would push the labels out of a single-line pill.
class _DialogActions extends StatelessWidget {
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmColor;

  const _DialogActions({
    required this.cancelLabel,
    required this.confirmLabel,
    required this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Cancel is a real, readable choice — not grey-on-grey. On a
    // destructive dialog the safe way out must not look disabled.
    final cancel = _DialogButton(
      label: cancelLabel,
      onTap: () => Navigator.pop(context, false),
      background: colors.surface,
      foreground: colors.textPrimary,
      borderColor: colors.border,
    );
    final confirm = _DialogButton(
      label: confirmLabel,
      onTap: () => Navigator.pop(context, true),
      background: confirmColor,
      foreground: colors.onPrimary,
    );

    // Two pills stop fitting once the labels are scaled well past their
    // design size; stack them rather than clipping the text.
    final stacked = MediaQuery.textScalerOf(context).scale(FontSize.s15) > 22;

    if (stacked) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [confirm, SizedBox(height: Insets.s12), cancel],
      );
    }

    // IntrinsicHeight + stretch keeps both pills the same height when one
    // label wraps to two lines and the other does not.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: cancel),
          SizedBox(width: Insets.s12),
          Expanded(child: confirm),
        ],
      ),
    );
  }
}

/// One dialog action: a pill that dims and shrinks slightly while held, so
/// a destructive tap gives real feedback instead of feeling inert.
class _DialogButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final Color? borderColor;

  const _DialogButton({
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 110),
            width: double.infinity,
            // minHeight, not a fixed height: the pill grows for a long or
            // scaled-up label instead of clipping it.
            constraints: BoxConstraints(minHeight: 50.h),
            padding:
                EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 12.h),
            decoration: BoxDecoration(
              color: _pressed
                  ? Color.alphaBlend(
                      Colors.black.withValues(alpha: 0.09), widget.background)
                  : widget.background,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: widget.borderColor == null
                  ? null
                  : Border.all(color: widget.borderColor!, width: 1.2),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                color: widget.foreground,
                fontSize: FontSize.s15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
