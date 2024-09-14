import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

abstract class ContactRepository {
  Future<Either<DataFailed, void>> acceptrequest(
      String userId, String contactId);

  Future<Either<DataFailed, void>> rejectrequest(
      String userId, String contactId);
}
