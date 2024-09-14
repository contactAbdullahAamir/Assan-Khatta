import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UserLogin implements Usecase<String, UserLoginParams> {
  final AuthRepository repository;

  const UserLogin({required this.repository});

  @override
  Future<Either<DataFailed, UserEntity>> call(UserLoginParams params) async {
    return await repository.loginWithEmail(params.email, params.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
