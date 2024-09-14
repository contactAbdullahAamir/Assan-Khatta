import '../../domain/enitities/wallet.dart';

sealed class WalletState {
  const WalletState();
}

final class WalletInitial extends WalletState {}

final class WalletLoading extends WalletState {}

final class WalletSuccess extends WalletState {
  final success;

  const WalletSuccess(this.success);
}

final class WalletFailure extends WalletState {
  final String message;

  const WalletFailure({required this.message});
}

final class WalletCreateSuccess extends WalletState {
  final WalletEntity wallet;

  WalletCreateSuccess({required this.wallet});
}
