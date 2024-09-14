class GroupState {
  const GroupState();
}

class GroupInitial extends GroupState {
  const GroupInitial();
}

class GroupLoading extends GroupState {
  const GroupLoading();
}

class GroupSuccess extends GroupState {
  final group;

  const GroupSuccess(
    this.group,
  );
}

class GetGroupSuccess extends GroupState {
  final groups;

  const GetGroupSuccess(this.groups);
}

class GroupFailure extends GroupState {
  final String message;

  const GroupFailure(
    this.message,
  );
}

class GetMemberSuccess extends GroupState {
  final members;

  const GetMemberSuccess(this.members);
}
