import '../../repositories/contact_repositories.dart';

class DeleteRequestUseCase {
  final ContactRepository repository;

  DeleteRequestUseCase(this.repository);

  Future<void> call(DeleteRequestUseCaseParams params) async {
    await repository.rejectrequest(params.userId, params.contactId);
  }
}

class DeleteRequestUseCaseParams {
  final String userId;
  final String contactId;

  DeleteRequestUseCaseParams({required this.userId, required this.contactId});
}
