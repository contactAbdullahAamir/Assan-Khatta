import 'package:assan_khata_frontend/features/wallet_management/domain/enitities/wallet.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    String? userId,
    int? balance,
    String? currency,
  }) : super(
          userId: userId,
          balance: balance,
          currency: currency,
        );

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['userId'],
      balance: json['balance'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'balance': balance,
      'currency': currency,
    };
  }
}
