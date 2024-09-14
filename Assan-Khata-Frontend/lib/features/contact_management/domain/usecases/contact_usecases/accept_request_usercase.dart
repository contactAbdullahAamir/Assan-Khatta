import 'package:assan_khata_frontend/features/contact_management/domain/repositories/contact_repositories.dart';

class AcceptRequestUseCase {
  final ContactRepository _contactRepository;

  AcceptRequestUseCase(this._contactRepository);

  Future<void> call(AcceptRequestUseCaseParams params) async {
    await _contactRepository.acceptrequest(params.userId, params.contactId);
  }
}

class AcceptRequestUseCaseParams {
  final String userId;
  final String contactId;

  AcceptRequestUseCaseParams({required this.userId, required this.contactId});
}
