import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phone;
  final String? name;

  const UserEntity({required this.id, required this.phone, this.name});

  @override
  List<Object?> get props => [id, phone, name];
}
