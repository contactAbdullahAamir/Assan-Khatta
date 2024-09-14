import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/profile_management/data/datasources/remote/user_remote_datasouce.dart';
import 'package:assan_khata_frontend/features/profile_management/domain/repositories/user_repositories.dart';
import 'package:fpdart/src/either.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasouce userRemoteDatasouce;

  const UserRepositoryImpl(this.userRemoteDatasouce);

  @override
  Future<Either<DataFailed, void>> updateUser(Map<String, dynamic> user) async {
    try {
      await userRemoteDatasouce.updateUser(user);
      return Right(user);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, UserEntity>> getUser(String id) async {
    try {
      final user = await userRemoteDatasouce.getUser(id);
      return Right(user);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, List<UserEntity>>> getAllUsers() async {
    try {
      final users = await userRemoteDatasouce.getAllUsers();
      return Right(users);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }
}
