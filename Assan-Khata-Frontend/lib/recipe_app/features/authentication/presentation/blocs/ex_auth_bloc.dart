import 'package:assan_khata_frontend/recipe_app/features/authentication/domain/usecases/login_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ex_auth_event.dart';
import 'ex_auth_state.dart';

class ExAuthBloc extends Bloc<ExAuthEvent, ExAuthState> {
  LoginUserUsecase _loginUserUsecase;

  ExAuthBloc({required LoginUserUsecase loginUserUsecase})
      : _loginUserUsecase = loginUserUsecase,
        super(ExAuthStateInitial()) {
    on<ExAuthEvent>((event, emit) => emit(ExAuthStateLoading()));
    on<ExAuthEventLogin>((event, emit) => _onLogin(event, emit));
  }

  Future _onLogin(ExAuthEventLogin event, Emitter<ExAuthState> emit) async {
    try {
      final result = await _loginUserUsecase(
          LoginUserUsecaseParams(email: event.email, password: event.password));
      result.fold((failure) {
        emit(ExAuthStateError(
            message: failure.errorMessage ?? 'An unknown error occurred'));
      }, (success) {
        emit(ExAuthStateLoginSuccess(token: success));
      });
    } catch (e) {
      emit(ExAuthStateError(
          message: "An unexpected error occurred: ${e.toString()}"));
    }
  }
}
