const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const walletSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    balance: { type: Number, default: 0 },
    currency: { type: String, default: "PKR" },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Wallet", walletSchema);
