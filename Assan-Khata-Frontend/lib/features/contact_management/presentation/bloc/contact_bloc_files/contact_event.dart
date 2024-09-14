sealed class ContactEvent {
  const ContactEvent();
}

class AcceptRequestEvent extends ContactEvent {
  final String userId;
  final String contactId;

  const AcceptRequestEvent(this.userId, this.contactId);
}

class DeleteRequestEvent extends ContactEvent {
  final String userId;
  final String contactId;

  const DeleteRequestEvent(this.userId, this.contactId);
}
