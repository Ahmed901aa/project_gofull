import 'package:flutter/material.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/tracked_dispatch.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Root navigator, for app-level redirects that originate outside the
/// widget tree (registered on MaterialApp.navigatorKey in main.dart).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Coalesces 401s that arrive within the same frame — driver home polls
/// the profile and the active request together, so one dead token yields
/// several simultaneous failures. Repeats across *later* frames are
/// prevented in ApiClient, which only calls this while a token still
/// exists (see `_onError`); no timer is needed, and none is left pending.
bool _redirecting = false;

@visibleForTesting
void debugResetSessionExpiryGuard() => _redirecting = false;

/// The stored session is no longer valid: the server rejected an
/// *authenticated* request with 401 because the token was revoked (a login
/// elsewhere — the API keeps one session per user), expired, or the
/// account was suspended.
///
/// Without this the app cleared the token and left the user stranded on a
/// screen whose every request now fails, showing the raw server string
/// "Unauthenticated." and a retry button that could never succeed. Send
/// them to login with one localized explanation instead.
void handleSessionExpired() {
  if (_redirecting) return;
  _redirecting = true;

  // Defer: a 401 can land mid-build (the interceptor runs during a frame),
  // and navigating from there would throw.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) {
      _redirecting = false;
      return;
    }

    navigator.pushNamedAndRemoveUntil(Routes.login, (route) => false);

    // Localizations may not have resolved yet on the very first frame;
    // the redirect matters more than the message, so never let a missing
    // translation break it.
    final context = rootNavigatorKey.currentContext;
    final l10n = context == null ? null : Localizations.of<S>(context, S);
    if (l10n != null) {
      rootScaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.sessionExpired),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }

    _redirecting = false;
  });

  // A settled, idle tree schedules no frames of its own, so the callback
  // above would sit unfired until something else happened to repaint —
  // leaving the user on the dead screen. Ask for a frame explicitly.
  WidgetsBinding.instance.scheduleFrame();
}
