import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String phone, String password);
  Future<Either<Failure, String>> sendOtp(String phone);
  Future<Either<Failure, UserEntity>> register(
    String name,
    String phone,
    String password,
    String passwordConfirmation,
    String role,
    String otpCode,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> changePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  );
}
