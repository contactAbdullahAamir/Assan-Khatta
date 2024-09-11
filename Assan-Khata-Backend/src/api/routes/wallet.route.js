const walletController = require("../controllers/wallet.controller");
const express = require("express");
const router = express.Router();

router.post("/createWallet", walletController.createWallet);
router.get("/getWallet/:id", walletController.getWallet);
router.get("/getWalletByUserId/:id", walletController.getWalletByUserId);
router.put("/updateWallet", walletController.updateWallet);
router.post("/transfer", walletController.transferFunds);


module.exports = router;
