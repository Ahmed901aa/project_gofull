import 'package:equatable/equatable.dart';
import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// SMS code request is in flight.
class OtpSending extends AuthState {
  const OtpSending();
}

/// SMS code sent — show the code entry UI.
class OtpSent extends AuthState {
  final String phone;
  final String message;
  const OtpSent({required this.phone, required this.message});

  @override
  List<Object?> get props => [phone, message];
}

class AuthFailure extends AuthState {
  final String message;

  /// True when the request never reached the server (connectivity), so the
  /// UI can show a localized connection message instead of [message].
  final bool isNetwork;

  const AuthFailure(this.message, {this.isNetwork = false});

  @override
  List<Object?> get props => [message, isNetwork];
}
