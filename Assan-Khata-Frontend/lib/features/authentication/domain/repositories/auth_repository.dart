import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/resources/data_source.dart';

abstract class AuthRepository {
  Future<Either<DataFailed, UserEntity>> signUpWithEmail(
    String name,
    String email,
    String password,
  );

  Future<Either<DataFailed, UserEntity>> verifyEmail(
    String email,
    String code,
  );

  Future<Either<DataFailed, UserEntity>> loginWithEmail(
    String email,
    String password,
  );

  Future<Either<DataFailed, void>> requestMagicLink(
    String email,
  );

  Future<Either<DataFailed, UserEntity>> verifyMagicLink(
    String token,
  );
}
