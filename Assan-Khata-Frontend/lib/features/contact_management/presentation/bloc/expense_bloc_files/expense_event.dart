import '../../../data/models/expense_model.dart';

sealed class ExpenseEvent {
  const ExpenseEvent();
}

class GetIncomingExpensesEvent extends ExpenseEvent {
  final String userId;

  const GetIncomingExpensesEvent(this.userId);
}

class GetOutgoingExpensesEvent extends ExpenseEvent {
  final String userId;

  const GetOutgoingExpensesEvent(this.userId);
}

class GetTotalAmountBwUsersEvent extends ExpenseEvent {
  final String currentId;
  final String selectedId;

  const GetTotalAmountBwUsersEvent(this.currentId, this.selectedId);
}

class getAllExpensesBetweenUsersEvent extends ExpenseEvent {
  final String currentId;
  final String selectedId;

  const getAllExpensesBetweenUsersEvent(this.currentId, this.selectedId);
}

class AddExpenseEvent extends ExpenseEvent {
  final ExpenseModel expense;

  const AddExpenseEvent(this.expense);
}

class UpdateExpenseEvent extends ExpenseEvent {
  final ExpenseModel expense;

  const UpdateExpenseEvent(this.expense);
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;

  const DeleteExpenseEvent(this.id);
}
