import 'package:assan_khata_frontend/features/contact_management/domain/usecases/contact_usecases/delete_request-usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/contact_usecases/accept_request_usercase.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final AcceptRequestUseCase _acceptRequestUseCase;
  final DeleteRequestUseCase _deleteRequestUseCase;

  ContactBloc({
    required AcceptRequestUseCase acceptRequestUseCase,
    required DeleteRequestUseCase deleteRequestUseCase,
  })  : _acceptRequestUseCase = acceptRequestUseCase,
        _deleteRequestUseCase = deleteRequestUseCase,
        super(ContactInitial()) {
    on<ContactEvent>((event, emit) {
      ContactLoading();
    });
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<DeleteRequestEvent>(_onDeleteRequest);
  }

  Future<void> _onAcceptRequest(
    AcceptRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await _acceptRequestUseCase(AcceptRequestUseCaseParams(
          userId: event.userId, contactId: event.contactId));
      emit(ContactSuccess('Contact request accepted'));
    } catch (e) {
      emit(ContactFailure(
        "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  Future<void> _onDeleteRequest(
    DeleteRequestEvent event,
    Emitter<ContactState> emit,
  ) async {
    try {
      await _deleteRequestUseCase(DeleteRequestUseCaseParams(
          userId: event.userId, contactId: event.contactId));
      emit(ContactSuccess('Contact request deleted'));
    } catch (e) {
      emit(ContactFailure(
        "An unexpected error occurred: ${e.toString()}",
      ));
    }
  }
}
