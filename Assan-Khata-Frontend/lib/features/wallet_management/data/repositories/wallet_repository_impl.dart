import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/wallet_management/domain/enitities/wallet.dart';
import 'package:assan_khata_frontend/features/wallet_management/domain/repositories/wallet_repository.dart';
import 'package:fpdart/src/either.dart';

import '../datasources/remote/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDatasource walletRemoteDatasource;

  const WalletRepositoryImpl({required this.walletRemoteDatasource});

  @override
  Future<Either<DataFailed, WalletEntity>> createWallet(
      String userId, String amount) async {
    try {
      final wallet = await walletRemoteDatasource.createWallet(userId, amount);
      return Right(wallet);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, WalletEntity>> getWallet(String userId) async {
    try {
      final wallet = await walletRemoteDatasource.getWallet(userId);
      return Right(wallet);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }

  @override
  Future<Either<DataFailed, String>> transferFunds(
      String senderId, String recipientEmail, String amount) async {
    try {
      final message = await walletRemoteDatasource.TranferFunds(
          senderId, recipientEmail, amount);
      return Right(message);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }
}
