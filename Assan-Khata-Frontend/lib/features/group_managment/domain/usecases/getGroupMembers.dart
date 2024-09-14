import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/group_repository.dart';

class GetGroupMemberUseCase {
  final GroupRepository groupRepository;

  GetGroupMemberUseCase(this.groupRepository);

  Future<Either<DataFailed, List<dynamic>>> call(
      GetGroupMemberUseCaseParams params) async {
    return await groupRepository.getGroupMembers(params.groupId);
  }
}

class GetGroupMemberUseCaseParams {
  final String groupId;

  GetGroupMemberUseCaseParams(this.groupId);
}
