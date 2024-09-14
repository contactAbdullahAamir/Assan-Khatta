abstract class UserEvent {}

class UpdateUserEvent extends UserEvent {
  final Map<String, dynamic> user;

  UpdateUserEvent({required this.user});
}

class GetContactsEvent extends UserEvent {
  final String userId;

  GetContactsEvent({required this.userId});
}

class GetUserEvent extends UserEvent {
  final String id;

  GetUserEvent({required this.id});
}

class GetMultipleUsersEvent extends UserEvent {
  final List<String> contactIds;

  GetMultipleUsersEvent({required this.contactIds});
}

class GetAllUsersEvent extends UserEvent {
  GetAllUsersEvent();
}
