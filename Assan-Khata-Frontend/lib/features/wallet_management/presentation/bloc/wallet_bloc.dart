import 'package:assan_khata_frontend/features/wallet_management/domain/usecases/get_wallet.dart';
import 'package:assan_khata_frontend/features/wallet_management/domain/usecases/tranfer_funds_usecase.dart';
import 'package:assan_khata_frontend/features/wallet_management/presentation/bloc/wallet_event.dart';
import 'package:assan_khata_frontend/features/wallet_management/presentation/bloc/wallet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_wallet.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final CreateWallet _createWallet;
  final GetWallet _getWallet;
  final TransferFundsUseCase _transferFundsUseCase;

  WalletBloc(
      {required CreateWallet createWallet,
      required GetWallet GetWallet,
      required TransferFundsUseCase TransferFundsUseCaseinstance})
      : _createWallet = createWallet,
        _getWallet = GetWallet,
        _transferFundsUseCase = TransferFundsUseCaseinstance,
        super(WalletInitial()) {
    on<WalletEvent>((event, emit) {
      WalletLoading();
    });
    on<WalletCreate>(_onWalletCreate);
    on<WalletGet>(_onGetWallet);
    on<TransferFunds>(_onWalletTransfer);
  }

  Future<void> _onWalletCreate(
    WalletCreate event,
    Emitter<WalletState> emit,
  ) async {
    final result =
        await _createWallet(CreateWalletParams(event.userId, event.balance));
    result.fold(
      (failure) => emit(WalletFailure(
          message: failure.errorMessage ?? 'An unknown error occurred')),
      (wallet) => emit(WalletCreateSuccess(wallet: wallet)),
    );
  }

  Future<void> _onGetWallet(
    WalletGet event,
    Emitter<WalletState> emit,
  ) async {
    final result = await _getWallet(GetWalletParams(event.userId));
    result.fold(
      (failure) => emit(WalletFailure(
          message: failure.errorMessage ?? 'An unknown error occurred')),
      (wallet) => emit(WalletCreateSuccess(wallet: wallet)),
    );
  }

  Future<void> _onWalletTransfer(
    TransferFunds event,
    Emitter<WalletState> emit,
  ) async {
    final result = await _transferFundsUseCase(TransferFundsUseCaseParams(
        senderId: event.senderId,
        recipientEmail: event.recipientEmail,
        amount: event.amount));
    result.fold(
      (failure) => emit(WalletFailure(message: failure.errorMessage!)),
      (message) => emit(WalletSuccess(message)),
    );
  }
}
