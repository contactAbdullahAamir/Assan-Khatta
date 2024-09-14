import 'package:fpdart/fpdart.dart';

import '../../../../core/resources/data_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<DataFailed, UserModel>> loginWithEmail(
      String email, String password) async {
    try {
      final user = await authRemoteDataSource.loginUser(email, password);
      return Right(user);
    } catch (e) {
      return Left(DataFailed(e.toString())); // Map error to DataFailed
    }
  }

  @override
  Future<Either<DataFailed, UserModel>> signUpWithEmail(
      String name, String email, String password) async {
    try {
      final user =
          await authRemoteDataSource.registerUser(name, email, password);
      return Right(user);
    } catch (e) {
      return Left(DataFailed(e.toString())); // Map error to DataFailed
    }
  }

  @override
  Future<Either<DataFailed, UserModel>> verifyEmail(
      String email, String code) async {
    try {
      final user = await authRemoteDataSource.verifyEmail(email, code);
      return Right(user);
    } catch (e) {
      return left(DataFailed(e.toString())); // Map error to DataFailed
    }
  }

  @override
  Future<Either<DataFailed, void>> requestMagicLink(String email) async {
    try {
      await authRemoteDataSource.requestMagicLink(email);
      return Right(unit);
    } catch (e) {
      return Left(DataFailed('Failed to send magic link: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DataFailed, UserModel>> verifyMagicLink(String token) async {
    try {
      final user = await authRemoteDataSource.verifyMagicLink(token);
      return Right(user);
    } catch (e) {
      return left(DataFailed(e.toString())); // Map error to DataFailed
    }
  }
}
