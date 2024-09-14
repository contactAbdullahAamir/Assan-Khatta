import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/group_managment/domain/entities/group_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class GroupRepository {
  Future<Either<DataFailed, GroupEntity>> createGroup(
      Map<String, dynamic> group);

  Future<Either<DataFailed, List<GroupEntity>>> getGroups(String id);

  Future<Either<DataFailed, List<dynamic>>> getGroupMembers(String id);
}
