class ExAuthState {
  const ExAuthState();
}

class ExAuthStateInitial extends ExAuthState {
  const ExAuthStateInitial();
}

class ExAuthStateLoading extends ExAuthState {
  const ExAuthStateLoading();
}

class ExAuthStateError extends ExAuthState {
  final String message;

  const ExAuthStateError({required this.message});
}

class ExAuthStateLoginSuccess extends ExAuthState {
  final String token;

  const ExAuthStateLoginSuccess({required this.token});
}
