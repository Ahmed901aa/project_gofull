import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.phone,
    super.name,
    required super.role,
    super.status,
    super.token,
    super.avatarUrl,
  });

  /// Field names the backend has historically used for a user's avatar URL.
  /// Kept public so ProfileScreen / other consumers can read the same list.
  static const avatarFieldNames = ['avatar_url', 'avatarUrl', 'image', 'photo'];

  /// Reads an avatar URL from a map using any of [avatarFieldNames]. Guarded
  /// against non-string values (some backends return a nested media object
  /// under `image`), and against empty strings that would otherwise short-
  /// circuit a `??` fallback chain in callers.
  static String? readAvatar(Map<String, dynamic> j) {
    for (final key in avatarFieldNames) {
      final v = j[key];
      if (v is String && v.isNotEmpty) return v;
    }
    return null;
  }

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
      avatarUrl: readAvatar(user),
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
        avatarUrl: readAvatar(json),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        'role': role,
        'status': status,
        'token': token,
        'avatar_url': avatarUrl,
      };
}
