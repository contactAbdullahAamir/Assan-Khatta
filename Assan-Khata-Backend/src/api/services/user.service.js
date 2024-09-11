const userModel = require("../models/user.model");
const bcrypt = require("bcryptjs");
const mongoose = require("mongoose");

exports.changeUser = async (updatedUser) => {
  try {
    const retrievedUser = updatedUser.user;
    const user = await userModel.findOne({ email: retrievedUser.email });
    if (!user) {
      throw new Error("User not found");
    }

    const updatePromises = Object.keys(retrievedUser).map(async (key) => {
      if (key === "password") {
        const hashedPassword = await bcrypt.hash(retrievedUser[key], 10);
        user[key] = hashedPassword;
      } else {
        user[key] = retrievedUser[key];
      }
    });

    await Promise.all(updatePromises);
    await user.save();
    return user;
  } catch (err) {
    throw new Error(err.message);
  }
};

exports.getUserById = async (id) => {
  try {
    // Check if ID is valid
    if (!mongoose.Types.ObjectId.isValid(id)) {
      throw new Error("Invalid ID format");
    }

    // Fetch the user by ID
    const user = await userModel.findById(id);

    if (!user) {
      throw new Error("User not found");
    }

    return user;
  } catch (err) {
    throw new Error(`Error fetching user: ${err.message}`);
  }
};

exports.getAllUsers = async () => {
  try {
    const users = await userModel.find();
    return users;
  } catch (err) {
    throw new Error(`Error fetching users: ${err.message}`);
  }
};

exports.getUserByEmail = async (email) => {
  try {
    const user = await userModel.findOne({
      email: email,
    });
    if (!user) {
      throw new Error("User not found");
    }
    return user;
  } catch (err) {
    throw new Error(`Error fetching user: ${err.message}`);
  }
};
