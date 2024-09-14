import 'package:assan_khata_frontend/features/group_managment/domain/usecases/create_group_usecase.dart';
import 'package:assan_khata_frontend/features/group_managment/domain/usecases/getGroupMembers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_groups_usecase.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroupUseCase _createGroup;
  final GetGroupUseCase _getGroup;
  final GetGroupMemberUseCase _getGroupMembers;

  GroupBloc({
    required CreateGroupUseCase createGroup,
    required GetGroupUseCase getGroup,
    required GetGroupMemberUseCase getGroupMembers,
  })  : _createGroup = createGroup,
        _getGroup = getGroup,
        _getGroupMembers = getGroupMembers,
        super(GroupInitial()) {
    on<GroupEvent>((event, emit) {
      GroupLoading();
    });
    on<CreateGroupEvent>(_onCreateGroup);
    on<GetGroupsEvent>(_onGetGroups);
    on<GetMembersEvent>(_onGetGroupMembers);
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    // Emit loading state

    try {
      final result = await _createGroup(CreateGroupUseCaseParams(event.group));

      // Handle result as Either type
      result.fold(
        (failure) {
          // Failure case
          emit(GroupFailure(failure
              .errorMessage!)); // Assuming DataFailed has a `message` field
        },
        (group) {
          // Success case
          emit(GroupSuccess(group));
        },
      );
    } catch (e) {
      // Handle unexpected errors
      emit(GroupFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onGetGroups(
    GetGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      final result = await _getGroup(GetGroupUseCaseParams(event.id));

      result.fold(
        (failure) {
          emit(GroupFailure(failure.errorMessage ?? "Unknown error occurred"));
        },
        (groups) {
          emit(GetGroupSuccess(groups));
        },
      );
    } catch (e, stackTrace) {
      print("Error in _onGetGroups: $e");
      print("Stack trace: $stackTrace");
      emit(GroupFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onGetGroupMembers(
    GetMembersEvent event,
    Emitter<GroupState> emit,
  ) async {
    try {
      final result =
          await _getGroupMembers(GetGroupMemberUseCaseParams(event.groupId));

      result.fold(
        (failure) {
          // Log the failure for debugging
          print('Failure: ${failure.errorMessage ?? "Unknown error occurred"}');
          emit(GroupFailure(failure.errorMessage ?? "Unknown error occurred"));
        },
        (members) {
          // Ensure `members` is in the correct format
          print('Members fetched: ${members.length}');
          emit(GetMemberSuccess(
              members)); // Ensure GetMemberSuccess constructor matches
        },
      );
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging
      print('Error in _onGetGroupMembers: $e');
      print('Stack trace: $stackTrace');
      emit(GroupFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
