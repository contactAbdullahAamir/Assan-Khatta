import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/wallet_management/domain/enitities/wallet.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/wallet_repository.dart';

class GetWallet {
  final WalletRepository _walletRepository;

  GetWallet(this._walletRepository);

  Future<Either<DataFailed, WalletEntity>> call(GetWalletParams params) async {
    return await _walletRepository.getWallet(params.userId);
  }
}

class GetWalletParams {
  final String userId;

  GetWalletParams(this.userId);
}
