import 'dart:convert';

import 'package:assan_khata_frontend/core/common/api_service.dart';
import 'package:assan_khata_frontend/features/contact_management/data/models/expense_model.dart';

class ExpenseRemoteDatasource {
  final ApiService apiService;

  const ExpenseRemoteDatasource(this.apiService);

  Future<int> getIncomingAmount(String userId) async {
    try {
      final response =
          await apiService.post('/expense/getTotalIncomingExpenses/', {
        'userId': userId,
      });
      final responseBody = jsonDecode(response.body);
      return int.parse(responseBody['incomingTotalAmount'].toString());
    } catch (e) {
      throw Exception('Failed to get incoming amount: ${e.toString()}');
    }
  }

  Future<int> getOutgoingAmount(String userId) async {
    try {
      final response =
          await apiService.post('/expense/getTotalOutgoingExpenses/', {
        'userId': userId,
      });
      final responseBody = jsonDecode(response.body);
      return int.parse(responseBody['outgoingTotalAmount'].toString());
    } catch (e) {
      throw Exception('Failed to get outgoing amount: ${e.toString()}');
    }
  }

  Future<int> getTotalAmountBwUsers(
      String currentUser, String selectedUser) async {
    try {
      final response =
          await apiService.post('/expense/getTotalAmountBetweenUsers/', {
        'currentUser': currentUser,
        'selectedUser': selectedUser,
      });
      final responseBody = jsonDecode(response.body);
      return int.parse(responseBody['totalAmount'].toString());
    } catch (e) {
      throw Exception(
          'Failed to get total amount between users: ${e.toString()}');
    }
  }

  Future<List<ExpenseModel>> getAllExpensesbwUsers(
      String currentUser, String selectedUser) async {
    try {
      final response =
          await apiService.post('/expense/getExpensesBetweenUsers/', {
        'currentUser': currentUser,
        'selectedUser': selectedUser,
      });
      final responseBody = jsonDecode(response.body);
      return responseBody['expenses']
          .map<ExpenseModel>((expense) => ExpenseModel.fromJson(expense))
          .toList();
    } catch (e) {
      throw Exception(
          'Failed to get total amount between users: ${e.toString()}');
    }
  }

  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    try {
      final result =
          await apiService.post('/expense/create/', expense.toJson());
      final responseBody = result.statusCode == 201
          ? jsonDecode(result.body)
          : throw Exception('Failed to add expense');
      return ExpenseModel.fromJson(responseBody);
    } catch (e) {
      throw Exception('Failed to add expense: ${e.toString()}');
    }
  }

  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    try {
      final result = await apiService.post('/expense/edit', expense.toJson());
      final responseBody = result.statusCode == 200
          ? jsonDecode(result.body)
          : throw Exception('Failed to update expense');
      return ExpenseModel.fromJson(responseBody);
    } catch (e) {
      throw Exception('Failed to update expense: ${e.toString()}');
    }
  }

  Future<bool> deleteExpense(String id) async {
    try {
      // Log the ID being sent

      final result = await apiService.delete('/expense/delete', {
        'id': id,
      }); // Log the entire response body

      if (result.statusCode != 200) {
        throw Exception(
            'Failed to delete expense: Status ${result.statusCode}');
      }

      final responseBody = jsonDecode(result.body);

      return bool.parse(responseBody['acknowledged'].toString());
    } catch (e) {
      // Log any caught exceptions
      throw Exception('Failed to delete expense: ${e.toString()}');
    }
  }
}
