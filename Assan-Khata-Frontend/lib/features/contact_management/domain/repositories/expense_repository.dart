import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/expense_model.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/entities/expense_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ExpenseRepository {
  Future<Either<DataFailed, int>> getIncomingAmount(String userId);

  Future<Either<DataFailed, int>> getOutgoingAmount(String userId);

  Future<Either<DataFailed, int>> getTotalAmountBwUsers(
      String currentUser, String selectedUser);

  Future<Either<DataFailed, List<ExpenseEntity>>> getAllExpensesbwUsers(
      String currentUser, String selectedUser);

  Future<Either<DataFailed, ExpenseEntity>> addExpense(ExpenseModel expense);

  Future<Either<DataFailed, ExpenseEntity>> updateExpense(ExpenseModel expense);

  Future<Either<DataFailed, bool>> deleteExpense(String id);
}
