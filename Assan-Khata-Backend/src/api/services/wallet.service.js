const walletModel = require("../models/wallet.model");
const UserModel = require("../models/user.model");
const userModel = require("../models/user.model");

exports.createWallet = async (userId, balance) => {
  const existingWallet = await walletModel.findOne({ userId });
  if (existingWallet) {
    throw new Error("Wallet already exists for this user");
  }
  const wallet = await walletModel.create({ userId, balance });
  console.log(wallet);
  return wallet;
};

exports.getWallet = async (userId) => {
  const wallet = await walletModel.findOne({ _id: userId });
  if (!wallet) {
    throw new Error("Wallet not found");
  }
  return wallet;
};

exports.getWalletByUserId = async (userId) => {
  const wallet = await walletModel.findOne({ userId: userId });
  if (!wallet) {
    throw new Error("Wallet not found");
  }
  return wallet;
};

exports.updateWallet = async (userId, balance) => {
  const wallet = await walletModel.findOne({ _id: userId });
  if (!wallet) {
    throw new Error("Wallet not found");
  }
  wallet.balance += Number(balance);
  await wallet.save();
  return wallet;
};

exports.transferFunds = async (senderId, recipientEmail, amount) => {
  const balance = Number(amount);
  if (balance <= 0) {
    throw new Error("Transfer amount must be greater than zero.");
  }

  const senderWallet = await walletModel.findOne({ userId: senderId });
  const recipientId = await userModel.findOne({ email: recipientEmail });
  const recipientWallet = await walletModel.findOne({
    userId: recipientId._id,
  });

  console.log(senderWallet._id);
  console.log(recipientWallet._id);

  if (!senderWallet || !recipientWallet) {
    throw new Error("Sender or recipient wallet not found.");
  }

  if (senderWallet.balance < balance) {
    throw new Error("Insufficient funds in sender's wallet.");
  }

  // Perform the transfer
  senderWallet.balance -= balance;
  recipientWallet.balance += balance;

  // Save changes
  await senderWallet.save();
  await recipientWallet.save();

  return {
    senderWallet,
    recipientWallet,
    transferredAmount: balance,
  };
};
