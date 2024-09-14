import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RequestMagicLink {
  AuthRepository repository;

  RequestMagicLink({required this.repository});

  Future<Either<DataFailed, void>> call(RequestMagicLinkParams params) async {
    final result = await repository.requestMagicLink(params.email);
    return result;
  }
}

class RequestMagicLinkParams {
  final String email;

  RequestMagicLinkParams({required this.email});
}
