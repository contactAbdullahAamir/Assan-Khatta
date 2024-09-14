sealed class AuthEvent {}

final class AuthSignUpWithEmail extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUpWithEmail(
      {required this.name, required this.email, required this.password});
}

final class AuthLogInWithEmail extends AuthEvent {
  final String email;
  final String password;

  AuthLogInWithEmail({required this.email, required this.password});
}

final class AuthVerifyEmail extends AuthEvent {
  final String email;
  final String code;

  AuthVerifyEmail({required this.email, required this.code});
}

final class AuthRequestMagicLink extends AuthEvent {
  final String email;

  AuthRequestMagicLink({required this.email});
}

final class AuthVerifyMagicLink extends AuthEvent {
  final String token;

  AuthVerifyMagicLink({required this.token});
}
