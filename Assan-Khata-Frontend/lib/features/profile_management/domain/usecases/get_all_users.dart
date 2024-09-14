import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/user_repositories.dart';

class GetAllUsers {
  final UserRepository _userRepository;

  GetAllUsers(this._userRepository);

  Future<Either<DataFailed, List<UserEntity>>> call() async {
    return await _userRepository.getAllUsers();
  }
}
