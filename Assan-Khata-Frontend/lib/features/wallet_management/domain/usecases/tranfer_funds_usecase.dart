import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/wallet_repository.dart';

class TransferFundsUseCase {
  final WalletRepository walletRepository;

  TransferFundsUseCase({required this.walletRepository});

  Future<Either<DataFailed, String>> call(
      TransferFundsUseCaseParams params) async {
    return await walletRepository.transferFunds(
        params.senderId, params.recipientEmail, params.amount.toString());
  }
}

class TransferFundsUseCaseParams {
  final String senderId;
  final String recipientEmail;
  final int amount;

  TransferFundsUseCaseParams(
      {required this.senderId,
      required this.recipientEmail,
      required this.amount});
}
