import 'package:assan_khata_frontend/core/common/api_service.dart';

class ContactRemoteDataSource {
  ApiService apiService;

  ContactRemoteDataSource(this.apiService);

  Future<void> acceptContactRequest(String userId, String contactId) async {
    try {
      await apiService
          .post('/contact/accept', {"userId": userId, "contactId": contactId});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteContactRequest(String userId, String contactId) async {
    try {
      await apiService
          .post('/contact/reject', {"userId": userId, "contactId": contactId});
    } catch (e) {
      throw e.toString();
    }
  }
}
