import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/wallet_management/domain/enitities/wallet.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/wallet_repository.dart';

class CreateWallet {
  final WalletRepository _walletRepository;

  CreateWallet(this._walletRepository);

  Future<Either<DataFailed, WalletEntity>> call(
      CreateWalletParams params) async {
    return await _walletRepository.createWallet(params.userId, params.amount);
  }
}

class CreateWalletParams {
  final String userId;
  final String amount;

  CreateWalletParams(this.userId, this.amount);
}
