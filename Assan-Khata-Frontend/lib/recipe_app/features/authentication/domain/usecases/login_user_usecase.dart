import 'package:fpdart/fpdart.dart';

import '../../../../../core/resources/data_source.dart';
import '../repositories/ex_user_repositories.dart';

class LoginUserUsecase {
  final ExUserRepository repository;

  LoginUserUsecase({required this.repository});

  Future<Either<DataFailed, String>> call(LoginUserUsecaseParams params) async {
    return await repository.Login(params.email, params.password);
  }
}

class LoginUserUsecaseParams {
  final String email;
  final String password;

  LoginUserUsecaseParams({required this.email, required this.password});
}
