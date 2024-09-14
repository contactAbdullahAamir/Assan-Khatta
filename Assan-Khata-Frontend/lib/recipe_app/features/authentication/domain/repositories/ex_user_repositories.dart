import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

abstract class ExUserRepository {
  Future<Either<DataFailed, String>> Login(String email, String password);
}
