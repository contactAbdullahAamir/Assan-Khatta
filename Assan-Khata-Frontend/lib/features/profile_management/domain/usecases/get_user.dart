import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/profile_management/domain/repositories/user_repositories.dart';
import 'package:fpdart/fpdart.dart';

class GetUser {
  final UserRepository userRepository;

  const GetUser(this.userRepository);

  Future<Either<DataFailed, UserEntity>> call(GetUserParams params) async {
    final result = await userRepository.getUser(params.id);
    return result;
  }
}

class GetUserParams {
  final String id;

  GetUserParams({required this.id});
}
