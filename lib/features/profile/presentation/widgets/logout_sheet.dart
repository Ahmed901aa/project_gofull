import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Confirms signing out, as a bottom sheet.
///
/// Why a sheet and not a centre dialog: every other confirmation surface in
/// this app is a sheet (language, theme, rating, OTP, active order), so a
/// floating dialog was the one inconsistent moment in the flow. A sheet also
/// puts both actions in the thumb zone on a tall phone.
///
/// Why it shows the account: signing out is only ambiguous if you don't know
/// *which* account you're leaving. Showing the avatar, name and number turns
/// a generic warning into a specific, answerable question — and it costs
/// nothing, because the profile screen already has all three.
///
/// Returns true when the user confirmed.
Future<bool> showLogoutSheet(
  BuildContext context, {
  required String name,
  required String phone,
  required String initials,
  String? avatarUrl,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _LogoutSheetContent(
      name: name,
      phone: phone,
      initials: initials,
      avatarUrl: avatarUrl,
    ),
  );
  return result ?? false;
}

class _LogoutSheetContent extends StatelessWidget {
  final String name;
  final String phone;
  final String initials;
  final String? avatarUrl;

  const _LogoutSheetContent({
    required this.name,
    required this.phone,
    required this.initials,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = S.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.s24)),
      ),
      padding: EdgeInsets.fromLTRB(Insets.s20, 8.h, Insets.s20, Insets.s16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle — same 40x4 pill the app's other sheets use.
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20.h),

            _AccountAvatar(
              initials: initials,
              avatarUrl: avatarUrl,
              size: 64.w,
            ),
            SizedBox(height: 12.h),

            Text(
              name,
              style: getBoldStyle(
                color: colors.textPrimary,
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            // A phone number is always read left-to-right, even in Arabic —
            // without this the leading zero can jump to the wrong end.
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                phone,
                style: getRegularStyle(
                  color: colors.textSecondary,
                  fontSize: FontSize.s14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),

            SizedBox(height: 18.h),
            Divider(color: colors.borderSubtle, height: 1),
            SizedBox(height: 18.h),

            Text(
              l10n.logoutTitle,
              style: getBoldStyle(
                color: colors.textPrimary,
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.logoutSubtitle,
              style: getRegularStyle(
                color: colors.textSecondary,
                fontSize: FontSize.s14,
              ).copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            // Leaving first, staying underneath: the safe option sits where
            // a stray thumb lands, which is also how iOS orders a
            // destructive action sheet.
            _SheetButton(
              label: l10n.logoutBtn,
              onTap: () => Navigator.pop(context, true),
              background: colors.error,
              foreground: colors.onPrimary,
            ),
            SizedBox(height: Insets.s12),
            _SheetButton(
              label: l10n.stayBtn,
              onTap: () => Navigator.pop(context, false),
              background: colors.surface,
              foreground: colors.textPrimary,
              borderColor: colors.border,
            ),
          ],
        ),
      ),
    );
  }
}

/// The account's photo, or its initial on the brand colour.
class _AccountAvatar extends StatelessWidget {
  final String initials;
  final String? avatarUrl;
  final double size;

  const _AccountAvatar({
    required this.initials,
    required this.size,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final url = avatarUrl;

    Widget fallback() => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: colors.primary,
          child: Text(
            initials,
            style: getBoldStyle(
              color: colors.onPrimary,
              fontSize: size * 0.4,
            ).copyWith(height: 1),
          ),
        );

    return Container(
      width: size + 8,
      height: size + 8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primary.withValues(alpha: 0.10),
      ),
      child: ClipOval(
        child: url != null && url.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => fallback(),
                placeholder: (_, __) => fallback(),
              )
            : fallback(),
      ),
    );
  }
}

/// Full-width sheet action that dims and shrinks slightly while held.
class _SheetButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final Color? borderColor;

  const _SheetButton({
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  @override
  State<_SheetButton> createState() => _SheetButtonState();
}

class _SheetButtonState extends State<_SheetButton> {
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
          scale: _pressed ? 0.98 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 110),
            width: double.infinity,
            // minHeight, not a fixed height: the pill grows for a long or
            // scaled-up label instead of clipping it.
            constraints: BoxConstraints(minHeight: 52.h),
            padding:
                EdgeInsets.symmetric(horizontal: Insets.s16, vertical: 12.h),
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
                fontSize: FontSize.s16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
