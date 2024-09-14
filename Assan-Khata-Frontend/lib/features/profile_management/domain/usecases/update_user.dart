import 'package:fpdart/fpdart.dart';

import '../../../../core/resources/data_source.dart';
import '../repositories/user_repositories.dart';

class UpdateUser {
  final UserRepository userRepository;

  UpdateUser({required this.userRepository});

  Future<Either<DataFailed, void>> call(UpdateUserParams params) async {
    return await userRepository.updateUser(params.user);
  }
}

class UpdateUserParams {
  final Map<String, dynamic> user;

  UpdateUserParams({required this.user});
}
