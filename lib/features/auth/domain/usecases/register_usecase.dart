import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';
import 'package:project_gofull/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) =>
      repository.register(
        params.name,
        params.phone,
        params.password,
        params.passwordConfirmation,
        params.role,
      );
}

class RegisterParams extends Equatable {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String role;

  const RegisterParams({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
  });

  @override
  List<Object?> get props => [name, phone, password, passwordConfirmation, role];
}
