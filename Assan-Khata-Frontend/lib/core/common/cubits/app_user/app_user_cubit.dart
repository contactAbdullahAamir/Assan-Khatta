import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(UserEntity? user) {
    if (user != null) {
      emit(AppUserLoggedIn(user));
    } else {
      emit(AppUserInitial());
    }
  }
}
