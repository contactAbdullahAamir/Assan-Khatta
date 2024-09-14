import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../common/entities/user.dart';

abstract class Usecase<T, P> {
  Future<Either<DataFailed, UserEntity>> call(P params);
}
