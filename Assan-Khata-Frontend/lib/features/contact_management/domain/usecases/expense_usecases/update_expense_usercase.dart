import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/expense_model.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/entities/expense_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository _repository;

  UpdateExpenseUseCase(this._repository);

  Future<Either<DataFailed, ExpenseEntity>> call(
      UpdateExpenseUseCaseParams params) async {
    try {
      return await _repository.updateExpense(params.expense);
    } catch (e) {
      return Left(DataFailed('Failed to update expense: ${e.toString()}'));
    }
  }
}

class UpdateExpenseUseCaseParams {
  final ExpenseModel expense;

  UpdateExpenseUseCaseParams(this.expense);
}
