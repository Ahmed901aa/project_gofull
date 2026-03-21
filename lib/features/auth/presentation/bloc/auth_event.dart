import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpRequested extends AuthEvent {
  final String phone;
  const SendOtpRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpRequested extends AuthEvent {
  final String phone;
  final String code;
  const VerifyOtpRequested({required this.phone, required this.code});

  @override
  List<Object?> get props => [phone, code];
}
