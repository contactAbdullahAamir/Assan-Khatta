import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/expense_model.dart';
import 'package:assan_khata_frontend/features/contact_management/domain/entities/expense_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository _expenseRepository;

  AddExpenseUseCase(this._expenseRepository);

  Future<Either<DataFailed, ExpenseEntity>> call(
      AddExpenseUseCaseParams params) async {
    try {
      final result;
      return result = await _expenseRepository.addExpense(params.expense);
    } catch (e) {
      return Left(DataFailed('Failed to add expense: ${e.toString()}'));
    }
  }
}

class AddExpenseUseCaseParams {
  final ExpenseModel expense;

  AddExpenseUseCaseParams(this.expense);
}
