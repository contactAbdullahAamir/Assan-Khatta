import '../../../../core/common/entities/user.dart';

sealed class UserState {
  const UserState();
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final dynamic success; // This can be UserEntity or another type

  UserSuccess(this.success);
}

class ContactsSuccess extends UserState {
  final List<UserEntity> contacts;

  ContactsSuccess(this.contacts);
}

final class UserFailure extends UserState {
  final String message;

  const UserFailure({required this.message});
}
