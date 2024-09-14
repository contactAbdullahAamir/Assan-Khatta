import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/data/datasources/expense_remote_datasource.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/expense_model.dart';
import 'package:fpdart/src/either.dart';

import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDatasource _expenseDataSource;

  ExpenseRepositoryImpl(this._expenseDataSource);

  @override
  Future<Either<DataFailed, int>> getIncomingAmount(String userId) async {
    try {
      final incomingAmount = await _expenseDataSource.getIncomingAmount(userId);
      return Right(incomingAmount);
    } catch (e) {
      return Left(DataFailed('Failed to get incoming amount: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DataFailed, int>> getOutgoingAmount(String userId) async {
    try {
      final outgoingAmount = await _expenseDataSource.getOutgoingAmount(userId);
      return Right(outgoingAmount);
    } catch (e) {
      return Left(DataFailed('Failed to get outgoing amount: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DataFailed, int>> getTotalAmountBwUsers(
      String currentUser, String selectedUser) async {
    try {
      final totalAmount = await _expenseDataSource.getTotalAmountBwUsers(
          currentUser, selectedUser);
      return Right(totalAmount);
    } catch (e) {
      return Left(DataFailed(
          'Failed to get total amount between users: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DataFailed, List<ExpenseModel>>> getAllExpensesbwUsers(
      String currentUser, String selectedUser) async {
    try {
      final expenses = await _expenseDataSource.getAllExpensesbwUsers(
          currentUser, selectedUser);
      return Right(expenses);
    } catch (e) {
      return Left(DataFailed(
          'Failed to get total amount between users: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DataFailed, ExpenseModel>> addExpense(
      ExpenseModel expense) async {
    try {
      final expenseData = await _expenseDataSource.addExpense(expense);
      return Right(expenseData);
    } catch (e) {
      return Left(DataFailed('Failed to add expense: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DataFailed, ExpenseModel>> updateExpense(
      ExpenseModel expense) async {
    try {
      final expenseData = await _expenseDataSource.updateExpense(expense);
      return Right(expenseData);
    } catch (e) {
      return Left(DataFailed('Failed to update expense: ${e.toString()}'));
    }
  }

  @override
  Future<Either<DataFailed, bool>> deleteExpense(String id) async {
    try {
      final expenseData = await _expenseDataSource.deleteExpense(id);
      return Right(expenseData);
    } catch (e) {
      return Left(DataFailed('Failed to delete expense: ${e.toString()}'));
    }
  }
}
