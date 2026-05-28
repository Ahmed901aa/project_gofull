import 'package:dartz/dartz.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/core/error/failure.dart';
import 'package:project_gofull/features/auth/data/datasources/auth_data_source.dart';
import 'package:project_gofull/features/auth/domain/entities/user_entity.dart';
import 'package:project_gofull/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  const AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserEntity>> login(
      String phone, String password) async {
    try {
      final user = await dataSource.login(phone, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String phone,
    String password,
    String passwordConfirmation,
    String role,
  ) async {
    try {
      final user = await dataSource.register(
          name, phone, password, passwordConfirmation, role);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Right(null); // Always clear locally
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    try {
      final token = await dataSource.changePassword(
          currentPassword, newPassword, newPasswordConfirmation);
      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
