import 'package:assan_khata_frontend/features/group_managment/domain/entities/group_entity.dart';

class GroupEvent {
  const GroupEvent();
}

class CreateGroupEvent extends GroupEvent {
  final GroupEntity group;

  CreateGroupEvent(
    this.group,
  );
}

class GetGroupsEvent extends GroupEvent {
  final String id;

  GetGroupsEvent(
    this.id,
  );
}

class GetMembersEvent extends GroupEvent {
  final String groupId;

  GetMembersEvent(
    this.groupId,
  );
}
