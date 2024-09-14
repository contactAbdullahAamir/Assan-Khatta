class ExAuthEvent {
  ExAuthEvent();
}

class ExAuthEventLogin extends ExAuthEvent {
  final String email;
  final String password;

  ExAuthEventLogin({required this.email, required this.password});
}
