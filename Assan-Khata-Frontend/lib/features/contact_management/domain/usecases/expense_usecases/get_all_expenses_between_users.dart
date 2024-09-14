import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/entities/expense_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/expense_repository.dart';

class GetAllExpensesBetweenUsers {
  final ExpenseRepository repository;

  GetAllExpensesBetweenUsers(this.repository);

  @override
  Future<Either<DataFailed, List<ExpenseEntity>>> call(
      GetAllExpensesBetweenUsersParams params) async {
    return await repository.getAllExpensesbwUsers(
        params.currentUser, params.selectedUser);
  }
}

class GetAllExpensesBetweenUsersParams {
  final String currentUser;
  final String selectedUser;

  GetAllExpensesBetweenUsersParams(this.currentUser, this.selectedUser);
}
