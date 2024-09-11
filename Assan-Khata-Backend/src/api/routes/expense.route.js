const expenseController = require("../controllers/expense.controller");
const express = require("express");
const router = express.Router();

router.post("/create", expenseController.createExpense);
router.post("/edit", expenseController.editExpense);
router.delete("/delete", expenseController.deleteExpense);
router.post(
  "/getExpensesbyPayerId_recipientId",
  expenseController.getExpensesbyPayerId_recipientId
);
router.post("/updateExpenseStatus", expenseController.updateExpenseStatus);
router.post("/getExpensesByStatus", expenseController.getExpensesByStatus);
router.post(
  "/getTotalIncomingExpenses",
  expenseController.getTotalIncomingExpenses
);
router.post(
  "/getTotalOutgoingExpenses",
  expenseController.getTotalOutgoingExpenses
);
router.post(
  "/getExpensesBetweenUsers",
  expenseController.getExpensesBetweenUsers
);
router.post(
  "/getTotalAmountBetweenUsers",
  expenseController.gettotalAmountBetweenUsers
);

module.exports = router;
