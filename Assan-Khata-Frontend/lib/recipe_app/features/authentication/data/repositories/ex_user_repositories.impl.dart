import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/recipe_app/features/authentication/data/datasources/ex_auth_datasource.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/repositories/ex_user_repositories.dart';

class ExUserRepositoryImpl extends ExUserRepository {
  final ExAuthDatasource dataSource;

  ExUserRepositoryImpl({required this.dataSource});

  @override
  Future<Either<DataFailed, String>> Login(
      String email, String password) async {
    try {
      final result = await dataSource.login(email, password);
      return Right(result);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }
}
