import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.phone,
    super.name,
    required super.role,
    super.status,
    super.token,
  });

  /// Parses the full backend login/register response:
  /// ```json
  /// {
  ///   "success": true,
  ///   "data": {
  ///     "token": "...",
  ///     "user": { "id": 1, "name": "...", "phone": "...", "role": "driver", "status": "active" }
  ///   }
  /// }
  /// ```
  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;
    final token = data['token'] as String;

    return UserModel(
      id: user['id'] as int,
      phone: user['phone'] as String,
      name: user['name'] as String?,
      role: user['role'] as String,
      status: (user['status'] as String?) ?? 'active',
      token: token,
    );
  }

  /// Parses a flat user JSON (e.g. from local storage).
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        phone: json['phone'] as String,
        name: json['name'] as String?,
        role: json['role'] as String,
        status: (json['status'] as String?) ?? 'active',
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        'role': role,
        'status': status,
        'token': token,
      };
}
