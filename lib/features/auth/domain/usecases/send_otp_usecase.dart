import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase extends UseCase<void, SendOtpParams> {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) =>
      repository.sendOtp(params.phone);
}

class SendOtpParams extends Equatable {
  final String phone;
  const SendOtpParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
