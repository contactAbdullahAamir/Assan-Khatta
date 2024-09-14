import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/group_managment/domain/entities/group_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/group_repository.dart';

class GetGroupUseCase {
  final GroupRepository groupRepository;

  GetGroupUseCase(this.groupRepository);

  Future<Either<DataFailed, List<GroupEntity>>> call(
      GetGroupUseCaseParams params) async {
    try {
      final result = await groupRepository.getGroups(params.id);
      return result;
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }
}

class GetGroupUseCaseParams {
  final String id;

  GetGroupUseCaseParams(this.id);
}
