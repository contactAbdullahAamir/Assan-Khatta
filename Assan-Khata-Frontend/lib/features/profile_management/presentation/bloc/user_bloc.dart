import 'package:assan_khata_frontend/features/profile_management/domain/usecases/get_user.dart';
import 'package:assan_khata_frontend/features/profile_management/presentation/bloc/user_event.dart';
import 'package:assan_khata_frontend/features/profile_management/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entities/user.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../domain/usecases/update_user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateUser _updateUser; // Ensure this is UpdateUser, not UpdateTheUser
  final GetUser _getUser;
  final GetAllUsers _getAllUsers;

  UserBloc({
    required GetUser getUser,
    required UpdateUser updateUser,
    required GetAllUsers getAllUsers,
  })  : _updateUser = updateUser,
        _getUser = getUser,
        _getAllUsers = getAllUsers,
        super(UserInitial()) {
    on<UserEvent>((event, emit) {
      UserLoading();
    });
    on<UpdateUserEvent>(_onUpdateUser);
    on<GetUserEvent>(_onGetUser);
    on<GetMultipleUsersEvent>(_onGetMultipleUsers);
    on<GetAllUsersEvent>(_onGetAllUsers);
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final result = await _updateUser(UpdateUserParams(user: event.user));
      result.fold(
        (failure) => emit(UserFailure(
            message: failure.errorMessage ?? 'An unknown error occurred')),
        (user) => (users) => emit(
            UserSuccess(users)), // Make sure UserSuccess expects UserEntity
      );
    } catch (e) {
      emit(UserFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final result = await _getUser(GetUserParams(id: event.id));
      result.fold(
        (failure) => emit(UserFailure(
            message: failure.errorMessage ?? 'An unknown error occurred')),
        (user) => emit(UserSuccess(user)),
      );
    } catch (e) {
      emit(UserFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onGetMultipleUsers(
      GetMultipleUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading()); // Emit loading state initially
    try {
      final List<UserEntity> users = [];
      final List<String> contactIds = event.contactIds;
      if (contactIds.isNotEmpty) {
        for (final contactId in contactIds) {
          print(contactId);
          final result = await _getUser(GetUserParams(id: contactId));

          result.fold(
            (failure) {
              emit(UserFailure(
                message: failure.errorMessage ?? 'An unknown error occurred',
              ));
              return;
            },
            (user) {
              users.add(user);
            },
          );
        }
        emit(ContactsSuccess(users)); // Emit success state with fetched users
      }
    } catch (e) {
      emit(UserFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onGetAllUsers(
      GetAllUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final result = await _getAllUsers();
      result.fold(
        (failure) => emit(UserFailure(
            message: failure.errorMessage ?? 'An unknown error occurred')),
        (users) => emit(ContactsSuccess(users)),
      );
    } catch (e) {
      emit(UserFailure(
        message: "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }
}
