import 'package:flutter/material.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/tracked_dispatch.dart';
import 'package:project_gofull/l10n/app_localizations.dart';


final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();


bool _redirecting = false;

@visibleForTesting
void debugResetSessionExpiryGuard() => _redirecting = false;


void handleSessionExpired() {
  if (_redirecting) return;
  _redirecting = true;


  WidgetsBinding.instance.addPostFrameCallback((_) {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) {
      _redirecting = false;
      return;
    }

    navigator.pushNamedAndRemoveUntil(Routes.login, (route) => false);

  
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

  WidgetsBinding.instance.scheduleFrame();
}
