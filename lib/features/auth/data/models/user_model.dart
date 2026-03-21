import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.phone, super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        phone: json['phone'] as String,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'phone': phone, 'name': name};
}
