import '../../../domain/entities/expense_entity.dart';

sealed class ExpenseState {
  const ExpenseState();
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

class ExpenseSuccess extends ExpenseState {
  final expenses;

  const ExpenseSuccess(this.expenses);
}

class ExpenseAmountSuccess extends ExpenseState {
  final int incomingAmount;
  final int outgoingAmount;

  const ExpenseAmountSuccess(
      {required this.incomingAmount, required this.outgoingAmount});
}

class ExpenseAmountError extends ExpenseState {
  final String message;

  const ExpenseAmountError(this.message);
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);
}

class AllExpensesSuccess extends ExpenseState {
  final List<ExpenseEntity> expenses;

  const AllExpensesSuccess(this.expenses);
}

class AddExpenseSuccess extends ExpenseState {
  final expenses;

  const AddExpenseSuccess(this.expenses);
}
