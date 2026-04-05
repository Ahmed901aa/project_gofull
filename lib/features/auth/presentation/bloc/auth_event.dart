import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check if the user is already logged in (splash screen).
class CheckAuthRequested extends AuthEvent {
  const CheckAuthRequested();
}

/// Phone + Password login.
class LoginRequested extends AuthEvent {
  final String phone;
  final String password;
  const LoginRequested({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

/// Register a new account.
class RegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String role; // driver | provider

  const RegisterRequested({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
  });

  @override
  List<Object?> get props =>
      [name, phone, password, passwordConfirmation, role];
}

/// Logout and clear session.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
