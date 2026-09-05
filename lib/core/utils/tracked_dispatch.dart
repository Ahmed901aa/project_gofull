import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();


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
