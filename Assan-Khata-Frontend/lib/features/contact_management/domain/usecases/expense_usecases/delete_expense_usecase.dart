import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  DeleteExpenseUseCase(this._expenseRepository);

  Future<Either<DataFailed, bool>> call(
      DeleteExpenseUseCaseParams params) async {
    try {
      return await _expenseRepository.deleteExpense(params.id);
    } catch (e) {
      return Left(DataFailed(e.toString()));
    }
  }
}

class DeleteExpenseUseCaseParams {
  final String id;

  DeleteExpenseUseCaseParams(this.id);
}
