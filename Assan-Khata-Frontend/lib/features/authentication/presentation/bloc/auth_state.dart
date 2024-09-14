import '../../../../core/common/entities/user.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final success;

  const AuthSuccess(this.success);
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});
}

final class AuthLoginSuccess extends AuthState {
  final UserEntity user;

  AuthLoginSuccess({required this.user});
}
