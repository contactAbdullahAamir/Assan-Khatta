import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/repositories/expense_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTotalAmountBwUsers {
  final ExpenseRepository repository;

  GetTotalAmountBwUsers(this.repository);

  @override
  Future<Either<DataFailed, int>> call(
      GetTotalAmountBwUsersParams params) async {
    return await repository.getTotalAmountBwUsers(
        params.currentUser, params.selectedUser);
  }
}

class GetTotalAmountBwUsersParams {
  final String currentUser;
  final String selectedUser;

  GetTotalAmountBwUsersParams(
      {required this.currentUser, required this.selectedUser});
}
