import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/group_managment/data/datasources/group_remote_datasource.dart';
import 'package:assan_khata_frontend/features/group_managment/data/models/group_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDatasource remoteDataSource;

  GroupRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<DataFailed, GroupModel>> createGroup(
      Map<String, dynamic> group) async {
    try {
      final result = await remoteDataSource.createGroup(group);
      return Right(result);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, List<GroupModel>>> getGroups(String id) async {
    try {
      final result = await remoteDataSource.getGroups(id);
      return Right(result);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, List<dynamic>>> getGroupMembers(String id) async {
    try {
      final result = await remoteDataSource.getGroupMembers(id);
      return Right(result);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }
}
