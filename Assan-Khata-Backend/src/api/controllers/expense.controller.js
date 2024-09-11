const expenseService = require("../services/expense.service");

exports.createExpense = async (req, res) => {
  try {
    const {
      payer,
      amount,
      description,
      type,
      relatedUser,
      relatedGroup,
      picture,
    } = req.body;

    const expenseData = {
      payer,
      amount,
      description,
      type,
      relatedUser,
      relatedGroup,
      picture,
    };

    const expense = await expenseService.createExpense({
      expenseData,
    });
    res.status(201).json(expense);
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error creating expense", error: err.message });
  }
};

exports.editExpense = async (req, res) => {
  try {
    const { _id, amount, description, picture, status } = req.body;
    const updatedExpense = await expenseService.editExpense({
      _id,
      amount,
      description,
      picture,
      status,
    });
    res.status(200).json(updatedExpense);
  } catch (error) {
    res
      .status(400)
      .json({ message: "Error editing expense", error: error.message });
  }
};

exports.deleteExpense = async (req, res) => {
  try {
    const { id } = req.body;
    const deletedExpense = await expenseService.deleteExpense(id);
    res.status(200).json(deletedExpense);
  } catch (error) {
    res

      .status(400)
      .json({ message: "Error deleting expense", error: error.message });
  }
};
exports.getExpensesbyPayerId_recipientId = async (req, res) => {
  try {
    const { userId, recipientId } = req.body;
    const expenses = await expenseService.getExpensesbyPayerId_recipientId(
      userId,
      recipientId
    );
    res.status(200).json({ expenses: expenses });
  } catch (error) {
    res
      .status(400)
      .json({ message: "Error getting expenses", error: error.message });
  }
};

exports.updateExpenseStatus = async (req, res) => {
  try {
    const { expenseId, status } = req.body;
    const updatedExpense = await expenseService.updateExpenseStatus(
      expenseId,
      status
    );
    res.status(200).json(updatedExpense);
  } catch (error) {
    res
      .status(400)
      .json({ message: "Error updating expense status", error: error.message });
  }
};

exports.getExpensesByStatus = async (req, res) => {
  try {
    const { payer, recipientId, status } = req.body;
    const expenses = await expenseService.getExpensesByStatus(
      payer,
      recipientId,
      status
    );
    res.status(200).json(expenses);
  } catch (error) {
    res.status(400).json({
      message: "Error getting expenses by status",
      error: error.message,
    });
  }
};

exports.getTotalIncomingExpenses = async (req, res) => {
  try {
    const { userId } = req.body;
    const incomingTotalAmount = await expenseService.getTotalIncomingExpenses(
      userId
    );
    res.status(200).json({ incomingTotalAmount });
  } catch (error) {
    res.status(400).json({
      message: "Error getting total incoming expenses",
      error: error.message,
    });
  }
};

exports.getTotalOutgoingExpenses = async (req, res) => {
  try {
    const { userId } = req.body;
    const outgoingTotalAmount = await expenseService.getTotalOutgoingExpenses(
      userId
    );
    res.status(200).json({ outgoingTotalAmount });
  } catch (error) {
    res.status(400).json({
      message: "Error getting total outgoing expenses",
      error: error.message,
    });
  }
};

exports.getExpensesBetweenUsers = async (req, res) => {
  try {
    const { currentUser, selectedUser } = req.body;
    const expenses = await expenseService.getExpensesBetweenUsers(
      currentUser,
      selectedUser
    );
    res.status(200).json({ expenses });
  } catch (error) {
    res.status(400).json({
      message: "Error getting expenses between users",
      error: error.message,
    });
  }
};

exports.gettotalAmountBetweenUsers = async (req, res) => {
  try {
    const { currentUser, selectedUser } = req.body;
    const totalAmount = await expenseService.gettotalAmountBetweenUsers(
      currentUser,
      selectedUser
    );
    res.status(200).json({ totalAmount });
  } catch (error) {
    res.status(400).json({
      message: "Error getting total amount between users",
      error: error.message,
    });
  }
};
