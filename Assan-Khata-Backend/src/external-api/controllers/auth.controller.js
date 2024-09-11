const authService = require("../services/auth.service");

exports.register = async (req, res) => {
  try {
    const userData = {
      username: req.body.username,
      password: req.body.password,
      email: req.body.email,
    };

    const result = await authService.signup(userData);

    res.status(201).json(result);
  } catch (error) {
    res.status(500).send("Error during sign-up");
  }
};

exports.login = async (req, res) => {
  try {
    const userData = {
      email: req.body.email,
      password: req.body.password,
    };

    const result = await authService.login(userData);

    res.status(200).json(result);
  } catch (error) {
    res.status(500).send("Error during login");
  }
};

exports.verify = async (req, res) => {
  try {
    const userData = {
      userId: req.body.userId,
      otp: req.body.otp,
    };

    const result = await authService.verifyOtp(userData);

    res.status(200).json(result);
  } catch (error) {
    res.status(500).send("Error during OTP verification");
  }
};
