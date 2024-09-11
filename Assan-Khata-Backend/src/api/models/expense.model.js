const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const expenseSchema = new Schema({
  payer: { type: Schema.Types.ObjectId, ref: "User", required: true },
  amount: { type: Number, required: true },
  description: { type: String, required: true },
  type: { type: String, enum: ["individual", "group"], required: true }, // Type of expense
  relatedUser: { type: Schema.Types.ObjectId, ref: "User" }, // Used for individual expenses
  relatedGroup: { type: Schema.Types.ObjectId, ref: "Group" }, // Used for group expenses
  status: { type: String, enum: ["pending", "approved", "disapproved"], default: "pending" },
  picture: { type: String },
  createdAt: { type: Date, default: Date.now }
}, { timestamps: true });

module.exports = mongoose.model("Expense", expenseSchema);