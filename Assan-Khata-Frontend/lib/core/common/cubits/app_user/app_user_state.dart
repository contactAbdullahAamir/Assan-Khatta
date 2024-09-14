import 'package:assan_khata_frontend/core/common/entities/user.dart';

sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final UserEntity user;

  AppUserLoggedIn(this.user);
}
