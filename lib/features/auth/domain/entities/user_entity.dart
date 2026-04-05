import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String phone;
  final String? name;
  final String role; // driver | provider
  final String status; // active | suspended
  final String? token;

  const UserEntity({
    required this.id,
    required this.phone,
    this.name,
    required this.role,
    this.status = 'active',
    this.token,
  });

  bool get isDriver => role == 'driver';
  bool get isProvider => role == 'provider';

  @override
  List<Object?> get props => [id, phone, name, role, status, token];
}
