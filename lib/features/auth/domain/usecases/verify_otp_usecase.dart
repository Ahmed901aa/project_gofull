import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';
import 'package:project_gofull/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) =>
      repository.verifyOtp(params.phone, params.code);
}

class VerifyOtpParams extends Equatable {
  final String phone;
  final String code;
  const VerifyOtpParams({required this.phone, required this.code});

  @override
  List<Object?> get props => [phone, code];
}
