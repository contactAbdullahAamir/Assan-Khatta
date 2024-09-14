import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/core/usecases/usecase.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/common/entities/user.dart';
import '../repositories/auth_repository.dart';

class UserSignUp implements Usecase<String, UserSignUpParams> {
  final AuthRepository repository;

  const UserSignUp({required this.repository});

  @override
  Future<Either<DataFailed, UserEntity>> call(UserSignUpParams params) async {
    return await repository.signUpWithEmail(
        params.name, params.email, params.password);
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams(
      {required this.name, required this.email, required this.password});
}
