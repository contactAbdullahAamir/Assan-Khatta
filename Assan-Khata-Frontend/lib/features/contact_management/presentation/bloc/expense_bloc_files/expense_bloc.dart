import 'package:assan_khata_frontend/features/contact_management/domain/usecases/expense_usecases/add_expense_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/expense_usecases/delete_expense_usecase.dart';
import '../../../domain/usecases/expense_usecases/get_all_expenses_between_users.dart';
import '../../../domain/usecases/expense_usecases/get_incoming_amount.dart';
import '../../../domain/usecases/expense_usecases/get_outgoing_amount.dart';
import '../../../domain/usecases/expense_usecases/get_total_amount_bw_users.dart';
import '../../../domain/usecases/expense_usecases/update_expense_usercase.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  GetIncomingAmount _getIncomingAmount;
  GetOutgoingAmountAmount _getOutgoingAmountAmount;
  GetTotalAmountBwUsers _getTotalAmountBwUsers;
  GetAllExpensesBetweenUsers _getAllExpensesBetweenUsers;
  AddExpenseUseCase _addExpenseUseCase;
  UpdateExpenseUseCase _updateExpenseUseCase;
  DeleteExpenseUseCase _deleteExpenseUseCase;

  ExpenseBloc({
    required GetIncomingAmount getIncomingAmount,
    required GetOutgoingAmountAmount getOutgoingAmountAmount,
    required GetTotalAmountBwUsers getTotalAmountBwUsers,
    required GetAllExpensesBetweenUsers getAllExpensesBetweenUsers,
    required AddExpenseUseCase addExpenseUseCase,
    required UpdateExpenseUseCase updateExpenseUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
  })  : _getIncomingAmount = getIncomingAmount,
        _getOutgoingAmountAmount = getOutgoingAmountAmount,
        _getTotalAmountBwUsers = getTotalAmountBwUsers,
        _getAllExpensesBetweenUsers = getAllExpensesBetweenUsers,
        _addExpenseUseCase = addExpenseUseCase,
        _updateExpenseUseCase = updateExpenseUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        super(ExpenseInitial()) {
    on<ExpenseEvent>((event, emit) {
      ExpenseLoading();
    });
    on<GetIncomingExpensesEvent>(_onGetIncomingExpenseAmount);
    on<GetOutgoingExpensesEvent>(_onGetOutgoingExpenseAmount);
    on<GetTotalAmountBwUsersEvent>(_onGetTotalAmountBwUsers);
    on<getAllExpensesBetweenUsersEvent>(_onGetAllExpensesBetweenUsers);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onGetIncomingExpenseAmount(
    GetIncomingExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final result =
          await _getIncomingAmount(GetIncomingAmountParams(event.userId));
      final incomingAmount = result.fold(
        (failure) => throw Exception('Failed to fetch incoming amount'),
        (amount) => amount,
      );

      final currentState = state;
      if (currentState is ExpenseAmountSuccess) {
        emit(ExpenseAmountSuccess(
          incomingAmount: incomingAmount,
          outgoingAmount: currentState.outgoingAmount,
        ));
      } else {
        emit(ExpenseAmountSuccess(
          incomingAmount: incomingAmount,
          outgoingAmount: 0,
        ));
      }
    } catch (e) {
      emit(ExpenseAmountError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onGetOutgoingExpenseAmount(
    GetOutgoingExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      // Log the event and userId for debugging

      final result = await _getOutgoingAmountAmount(
          GetOutgoingAmountAmountParams(event.userId));

      // Log the result or error
      result.fold(
        (failure) {
          throw Exception('Failed to fetch outgoing amount');
        },
        (amount) {
          final currentState = state;
          if (currentState is ExpenseAmountSuccess) {
            emit(ExpenseAmountSuccess(
              incomingAmount: currentState.incomingAmount,
              outgoingAmount: amount,
            ));
          } else {
            emit(ExpenseAmountSuccess(
              incomingAmount: 0,
              outgoingAmount: amount,
            ));
          }
        },
      );
    } catch (e) {
      // Log the caught exception
      emit(ExpenseAmountError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onGetTotalAmountBwUsers(
    GetTotalAmountBwUsersEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final result = await _getTotalAmountBwUsers(GetTotalAmountBwUsersParams(
        currentUser: event.currentId,
        selectedUser: event.selectedId,
      ));

      result.fold(
        (failure) => emit(
            ExpenseError("Failed to retrieve amount: ${failure.toString()}")),
        (amount) => emit(ExpenseSuccess(amount)),
      );
    } catch (e) {
      emit(ExpenseError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onGetAllExpensesBetweenUsers(
    getAllExpensesBetweenUsersEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final result = await _getAllExpensesBetweenUsers(
        GetAllExpensesBetweenUsersParams(event.currentId, event.selectedId),
      );

      result.fold(
        (failure) {
          emit(ExpenseError(
              "Failed to retrieve expenses: ${failure.toString()}"));
        },
        (expenses) {
          emit(AllExpensesSuccess(expenses));
        },
      );
    } catch (e) {
      emit(ExpenseError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final result =
          await _addExpenseUseCase(AddExpenseUseCaseParams(event.expense));

      result.fold(
        (failure) {
          emit(ExpenseError("Failed to add expense: ${failure.toString()}"));
        },
        (expense) {
          emit(AddExpenseSuccess(expense));
        },
      );
    } catch (e) {
      emit(ExpenseError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final result = await _updateExpenseUseCase(
          UpdateExpenseUseCaseParams(event.expense));

      result.fold(
        (failure) {
          emit(ExpenseError("Failed to update expense: ${failure.toString()}"));
        },
        (expense) {
          emit(AddExpenseSuccess(expense));
        },
      );
    } catch (e) {
      emit(ExpenseError("An unexpected error occurred: ${e.toString()}"));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final result =
          await _deleteExpenseUseCase(DeleteExpenseUseCaseParams(event.id));

      result.fold(
        (failure) {
          emit(ExpenseError(failure.errorMessage!));
        },
        (expense) {
          emit(AddExpenseSuccess(expense));
        },
      );
    } catch (e) {
      emit(ExpenseError("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
