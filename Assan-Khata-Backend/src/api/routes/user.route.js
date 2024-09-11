const userController = require("../controllers/user.controller");
const express = require("express");
const router = express.Router();

router.put("/updateUser", userController.updateUser);
router.get('/getUser/:id', userController.getUser);
router.get('/getAllUsers', userController.getAllUsers);
router.get('/getUserByEmail/:email', userController.getUserByEmail);

module.exports = router;
