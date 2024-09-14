sealed class ContactState {
  const ContactState();
}

class ContactInitial extends ContactState {
  const ContactInitial();
}

class ContactLoading extends ContactState {
  const ContactLoading();
}

class ContactSuccess extends ContactState {
  final String message;

  const ContactSuccess(this.message);
}

class ContactFailure extends ContactState {
  final String message;

  const ContactFailure(this.message);
}
