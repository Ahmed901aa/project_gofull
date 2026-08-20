import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root messenger — lets outcome snackbars survive screen navigation
/// (registered on MaterialApp.scaffoldMessengerKey in main.dart).
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Dispatches an event on a throwaway bloc (from a GetIt factory), watches
/// for the terminal state, then closes the bloc.
///
/// Replaces the old fire-and-forget `sl<XBloc>().add(event)` pattern, which
/// silently discarded failures AND leaked the bloc: a driver could tap
/// "completed", the request could fail, and nobody would ever know.
///
/// On failure, [failureMessage] is shown on the ROOT messenger — visible
/// even if the calling screen has already navigated away.
void dispatchTracked<B extends BlocBase<S>, S>(
  B bloc, {
  required void Function(B bloc) send,
  required bool Function(S state) isSuccess,
  required bool Function(S state) isFailure,
  required String failureMessage,
  VoidCallback? onSuccess,
  VoidCallback? onFailure,
}) {
  late final StreamSubscription<S> sub;
  sub = bloc.stream.listen((state) {
    if (isSuccess(state)) {
      sub.cancel();
      bloc.close();
      onSuccess?.call();
    } else if (isFailure(state)) {
      sub.cancel();
      bloc.close();
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(failureMessage),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      onFailure?.call();
    }
  });
  send(bloc);
}
