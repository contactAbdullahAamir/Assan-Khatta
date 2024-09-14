import 'package:fpdart/fpdart.dart';

import '../../../../core/resources/data_source.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class CreateGroupUseCase {
  final GroupRepository _groupRepository;

  CreateGroupUseCase(this._groupRepository);

  Future<Either<DataFailed, GroupEntity>> call(
      CreateGroupUseCaseParams params) async {
    try {
      final result = await _groupRepository.createGroup(params.group.toJson());
      return result; // On success, return Right with GroupEntity
    } catch (e) {
      return Left(
          DataFailed(e.toString())); // On failure, return Left with DataFailed
    }
  }
}

class CreateGroupUseCaseParams {
  final GroupEntity group;

  CreateGroupUseCaseParams(this.group);
}
