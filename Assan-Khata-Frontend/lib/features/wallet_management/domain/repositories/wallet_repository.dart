import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/wallet_management/domain/enitities/wallet.dart';
import 'package:fpdart/fpdart.dart';

abstract class WalletRepository {
  Future<Either<DataFailed, WalletEntity>> createWallet(
    String userId,
    String amount,
  );

  Future<Either<DataFailed, WalletEntity>> getWallet(String userId);

  Future<Either<DataFailed, String>> transferFunds(
    String senderId,
    String recipientEmail,
    String amount,
  );
}
