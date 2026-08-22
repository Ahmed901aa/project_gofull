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

/// Send an SMS verification code before registering.
class SendOtpRequested extends AuthEvent {
  final String phone;
  const SendOtpRequested({required this.phone});

  @override
  List<Object?> get props => [phone];
}

/// Register a new account (requires the SMS code from [SendOtpRequested]).
class RegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String role; // driver | provider
  final String otpCode;

  const RegisterRequested({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
    required this.otpCode,
  });

  @override
  List<Object?> get props =>
      [name, phone, password, passwordConfirmation, role, otpCode];
}

/// Logout and clear session.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
