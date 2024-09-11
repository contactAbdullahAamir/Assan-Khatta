const Expense = require("../models/expense.model");
const walletService = require("./wallet.service");
const groupModel = require("../models/group.model");

class ExpenseService {
  static async createExpense(expenseData) {
    try {
      const expense = new Expense(expenseData.expenseData);
      const group = await groupModel.findById(expense.relatedGroup);
      if (expense.payer != expense.relatedUser) {
        const wallet = await walletService.getWalletByUserId(expense.payer);

        if (wallet.balance >= expense.amount) {
          await walletService.updateWallet(wallet._id, -expense.amount);
        } else {
          throw new Error("Insufficient funds");
        }
      }
      return await expense.save();
    } catch (error) {
      throw error;
    }
  }

  static async editExpense(expenseData) {
    try {
      const expense = await Expense.findById(expenseData._id);
      if (!expense) {
        throw new Error("Expense not found");
      }
      if (expenseData.amount) {
        expense.amount = expenseData.amount;
      }
      if (expenseData.description) {
        expense.description = expenseData.description;
      }
      if (expenseData.picture) {
        expense.picture = expenseData.picture;
      }
      if (expenseData.status) {
        expense.status = expenseData.status;
      }
      return await expense.save();
    } catch (error) {
      throw error;
    }
  }

  static async deleteExpense(expenseId) {
    try {
      const expense = await Expense.findById(expenseId);
      if (!expense) {
        throw new Error("Expense not found");
      }
      const wallet = await walletService.getWalletByUserId(expense.payer);
      await walletService.updateWallet(wallet._id, expense.amount);
      return await expense.deleteOne();
    } catch (error) {
      throw error;
    }
  }

  static async getExpensesbyPayerId_recipientId(userId, recipientId) {
    try {
      return await Expense.find({
        payer: userId,
        $or: [{ relatedUser: recipientId }, { relatedGroup: recipientId }],
      });
    } catch (error) {
      throw error;
    }
  }

  static async updateExpenseStatus(expenseId, status) {
    try {
      const expense = await Expense.findById(expenseId);
      if (!expense) {
        throw new Error("Expense not found");
      }
      expense.status = status;

      if (status === "disapproved") {
        const wallet = await walletService.getWalletByUserId(expense.payer);
        await walletService.updateWallet(wallet._id, expense.amount);
      }
      return await expense.save();
    } catch (error) {
      throw error;
    }
  }

  static async getExpensesByStatus(payer, recipientId, status) {
    try {
      const expenses = await Expense.find({
        payer,
        $or: [{ relatedUser: recipientId }, { relatedGroup: recipientId }],
        status,
      });

      if (expenses.length === 0) {
        throw new Error("No expenses found");
      }

      return expenses;
    } catch (error) {
      throw error;
    }
  }
  static async getTotalIncomingExpenses(userId) {
    try {
      const expenses = await Expense.find({
        relatedUser: userId,
        status: "approved",
      });
      const expenses2 = await Expense.find({
        payer: userId,
        status: "approved",
      });
      const totalAmount = expenses.reduce(
        (sum, expense) => sum + expense.amount,
        0
      );
      const totalAmount2 = expenses2.reduce(
        (sum, expense) => sum + expense.amount,
        0
      );
      const newAmount = totalAmount - totalAmount2;
      if (newAmount > 0) {
        return newAmount;
      } else {
        return 0;
      }
    } catch (error) {
      throw error;
    }
  }

  static async getTotalOutgoingExpenses(userId) {
    try {
      const expenses = await Expense.find({
        payer: userId,
        status: "approved",
      });
      const expenses2 = await Expense.find({
        relatedUser: userId,
        status: "approved",
      });
      const totalAmount = expenses.reduce(
        (sum, expense) => sum + expense.amount,
        0
      );

      const totalAmount2 = expenses2.reduce(
        (sum, expense) => sum + expense.amount,
        0
      );
      const newAmount = totalAmount - totalAmount2;
      if (newAmount > 0) {
        return newAmount;
      } else {
        return 0;
      }
    } catch (error) {
      throw error;
    }
  }

  static async getExpensesBetweenUsers(userId1, userId2) {
    try {
      const expenses = await Expense.find({
        $or: [
          { payer: userId1, relatedUser: userId2 },
          { payer: userId2, relatedUser: userId1 },
        ],
      });
      return expenses;
    } catch (error) {
      throw error;
    }
  }

  static async gettotalAmountBetweenUsers(currentUser, selectedUser) {
    try {
      const expenses = await Expense.find({
        payer: currentUser,
        relatedUser: selectedUser,
        status: "approved",
      });

      const expenses2 = await Expense.find({
        payer: selectedUser,
        relatedUser: currentUser,
        status: "approved",
      });

      const totalAmount = expenses.reduce(
        (sum, expense) => sum + expense.amount,
        0
      );

      const totalAmount2 = expenses2.reduce(
        (sum, expense) => sum + expense.amount,
        0
      );

      const totalAmountBetweenUsers = totalAmount2 - totalAmount;

      return totalAmountBetweenUsers;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = ExpenseService;
