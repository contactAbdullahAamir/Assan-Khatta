import 'dart:convert';

import 'package:assan_khata_frontend/core/common/api_service.dart';
import 'package:assan_khata_frontend/features/wallet_management/data/models/wallet.dart';

class WalletRemoteDatasource {
  final ApiService apiService;

  WalletRemoteDatasource({required this.apiService});

  Future<WalletModel> createWallet(String userId, String amount) async {
    try {
      final response = await apiService.post('/wallet/createWallet', {
        'id': userId,
        'balance': amount,
      });
      final responseBody = jsonDecode(response.body);
      return WalletModel.fromJson(responseBody['wallet']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<WalletModel> getWallet(String userId) async {
    try {
      final response =
          await apiService.get('/wallet/getWalletByUserId/$userId');
      final responseBody = jsonDecode(response.body);
      return WalletModel.fromJson(responseBody['wallet']);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> TranferFunds(
      String senderId, String recipientEmail, String amount) async {
    try {
      final response = await apiService.post('/wallet/transfer', {
        'senderId': senderId,
        'recipientEmail': recipientEmail,
        'amount': amount,
      });
      final responseBody = jsonDecode(response.body);
      return responseBody['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
