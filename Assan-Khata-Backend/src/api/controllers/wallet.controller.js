const walletService = require("../services/wallet.service");

exports.createWallet = async (req, res) => {
  try {
    const { id, balance } = req.body;
    const wallet = await walletService.createWallet(id, balance);
    res
      .status(201)
      .json({ wallet: wallet, message: "Wallet created successfully" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.getWallet = async (req, res) => {
  try {
    const { id } = req.params;
    const wallet = await walletService.getWallet(id);
    res.status(200).json({wallet: wallet});
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.getWalletByUserId = async (req, res) => {
  try {
    const { id } = req.params;
    const wallet = await walletService.getWalletByUserId(id);
    res.status(200).json({wallet: wallet});
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.updateWallet = async (req, res) => {
  try {
    const { id, balance } = req.body;
    const wallet = await walletService.updateWallet(id, balance);
    res.status(200).json(wallet);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.transferFunds = async (req, res) => {
  try {
    const { recipientEmail, amount } = req.body;
    const senderId = req.body.senderId; // Assuming the authenticated user's ID is in req.user

    const transferResult = await walletService.transferFunds(
      senderId,
      recipientEmail,
      amount
    );

    res.status(200).json({
      message: "Transfer successful",
      transferResult,
    });
  } catch (err) {
    res.status(400).json({
      message: "Transfer failed",
      error: err.message,
    });
  }
};
