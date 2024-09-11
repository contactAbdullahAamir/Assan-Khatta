const userService = require("../services/user.service");

exports.updateUser = async (req, res) => {
  try {
    let updatedUser = {}; // Initialize as an object
    updatedUser = req.body; // Destructure req.body

    const user = await userService.changeUser(updatedUser);
    res.status(200).json({ user });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getUser = async (req, res) => {
  try {
    const user = await userService.getUserById(req.params.id);
    res.json({user: user});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAllUsers = async (req, res) => {
  try {
    const users = await userService.getAllUsers();
    res.json({users: users});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getUserByEmail = async (req, res) => {
  try {
    const user = await userService.getUserByEmail(req.params.email);
    res.json({user: user});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};