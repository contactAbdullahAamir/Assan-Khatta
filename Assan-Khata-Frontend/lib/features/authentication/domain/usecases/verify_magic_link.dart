import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyMagicLink implements Usecase<String, VerifyMagicLinkParams> {
  final AuthRepository repository;

  VerifyMagicLink({required this.repository});

  @override
  Future<Either<DataFailed, UserEntity>> call(
      VerifyMagicLinkParams params) async {
    return await repository.verifyMagicLink(params.token);
  }
}

class VerifyMagicLinkParams {
  final String token;

  VerifyMagicLinkParams({required this.token});
}
