import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/resources/data_source.dart';

abstract class UserRepository {
  Future<Either<DataFailed, void>> updateUser(Map<String, dynamic> user);

  Future<Either<DataFailed, UserEntity>> getUser(String id);

  Future<Either<DataFailed, List<UserEntity>>> getAllUsers();
}
