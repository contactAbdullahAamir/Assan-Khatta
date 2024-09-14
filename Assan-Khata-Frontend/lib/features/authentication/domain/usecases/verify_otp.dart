import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp({required this.repository});

  Future<Either<DataFailed, UserEntity>> call(VerifyOtpParams params) async {
    return await repository.verifyEmail(params.email, params.code);
  }
}

class VerifyOtpParams {
  final String email;
  final String code;

  VerifyOtpParams({required this.email, required this.code});
}
