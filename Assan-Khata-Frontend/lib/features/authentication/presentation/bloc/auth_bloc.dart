import 'package:assan_khata_frontend/features/authentication/domain/usecases/request_magic_link.dart';
import 'package:assan_khata_frontend/features/authentication/domain/usecases/verify_otp.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_event.dart';
import 'package:assan_khata_frontend/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../domain/usecases/user_login.dart';
import '../../domain/usecases/user_signup.dart';
import '../../domain/usecases/verify_magic_link.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final VerifyOtp _verifyOtp;
  final RequestMagicLink _requestMagicLink;
  final VerifyMagicLink _verifyMagicLink;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required AppUserCubit appUserCubit,
    required VerifyOtp verifyOtp,
    required RequestMagicLink requestMagicLink,
    required VerifyMagicLink verifyMagicLink,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _appUserCubit = appUserCubit,
        _verifyOtp = verifyOtp,
        _requestMagicLink = requestMagicLink,
        _verifyMagicLink = verifyMagicLink,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUpWithEmail>(_onAuthSignUpWithEmail);
    on<AuthLogInWithEmail>(_onAuthLogInWithEmail);
    on<AuthVerifyEmail>(_onAuthVerifyEmail);
    on<AuthRequestMagicLink>(_onAuthRequestMagicLink);
    on<AuthVerifyMagicLink>(_onVerifyMagicLink);
  }

  Future<void> _onAuthRequestMagicLink(
    AuthRequestMagicLink event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result =
          await _requestMagicLink(RequestMagicLinkParams(email: event.email));
      result.fold((failure) {
        print('Auth failed: ${failure}');
        emit(AuthFailure(
            message: failure.errorMessage ?? 'An unknown error occurred'));
      }, (_) {
        emit(AuthSuccess('Auth succeeded'));
      });
    } catch (e) {
      emit(AuthFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onVerifyMagicLink(
    AuthVerifyMagicLink event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _verifyMagicLink(
        VerifyMagicLinkParams(token: event.token),
      );
      response.fold(
        (failed) => emit(AuthFailure(
            message: failed.errorMessage ?? 'An unknown error occurred')),
        (success) => _emitAuthSuccess(success, emit),
      );
    } catch (e) {
      emit(AuthFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onAuthVerifyEmail(
    AuthVerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _verifyOtp(
        VerifyOtpParams(
          email: event.email,
          code: event.code,
        ),
      );
      response.fold(
        (failed) => emit(AuthFailure(
            message: failed.errorMessage ?? 'An unknown error occurred')),
        (success) => _emitAuthSuccess(success, emit),
      );
    } catch (e) {
      emit(AuthFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onAuthSignUpWithEmail(
    AuthSignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _userSignUp(
        UserSignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );
      response.fold(
        (failed) => emit(AuthFailure(
            message: failed.errorMessage ?? 'An unknown error occurred')),
        (success) => _emitAuthSuccess(success, emit),
      );
    } catch (e) {
      emit(AuthFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onAuthLogInWithEmail(
    AuthLogInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _userLogin(
        UserLoginParams(
          email: event.email,
          password: event.password,
        ),
      );
      response.fold(
        (failed) => emit(AuthFailure(
            message: failed.errorMessage ?? 'An unknown error occurred')),
        (success) => _emitAuthSuccess(success, emit),
      );
    } catch (e) {
      emit(AuthFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  void _emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
