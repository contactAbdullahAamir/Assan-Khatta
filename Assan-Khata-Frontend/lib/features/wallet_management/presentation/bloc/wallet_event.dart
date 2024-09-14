sealed class WalletEvent {}

final class WalletCreate extends WalletEvent {
  final String userId;
  final String balance;

  WalletCreate({required this.userId, required this.balance});
}

final class WalletGet extends WalletEvent {
  final String userId;

  WalletGet({required this.userId});
}

final class TransferFunds extends WalletEvent {
  final String senderId;
  final String recipientEmail;
  final int amount;

  TransferFunds(this.senderId, this.recipientEmail, this.amount);
}
