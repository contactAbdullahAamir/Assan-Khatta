import 'package:assan_khata_frontend/features/contact_management/data/datasources/contact_remote_datasource.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/resources/data_source.dart';
import '../../domain/repositories/contact_repositories.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource contactDataSource;

  ContactRepositoryImpl({required this.contactDataSource});

  @override
  Future<Either<DataFailed, void>> acceptrequest(
      String userId, String contactId) async {
    try {
      final contacts =
          await contactDataSource.acceptContactRequest(userId, contactId);
      return Right(contacts);
    } on Exception {
      return Left(DataFailed('Error fetching contacts'));
    }
  }

  @override
  Future<Either<DataFailed, void>> rejectrequest(
      String userId, String contactId) async {
    try {
      final contacts =
          await contactDataSource.deleteContactRequest(userId, contactId);

      return Right(contacts);
    } on Exception {
      return Left(DataFailed('Error fetching contacts'));
    }
  }
}
