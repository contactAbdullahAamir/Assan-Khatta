const authService = require("../services/auth.service");

exports.register = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const user = await authService.registerUser(name, email, password);
    res.status(201).json({
      user: user,
      message: "User registered, please check your email for verification code",
    });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const { jwtToken, user } = await authService.loginUser(
      email,
      password,
      req.app.get("io")
    );
    res.status(200).json({ token: jwtToken, user: user });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.verifyEmail = async (req, res) => {
  try {
    const { email, code } = req.body;
    const user = await authService.verifyEmail(email, code);
    res
      .status(200)
      .json({ message: "Email verified successfully", user: user });
    return user;
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.requestMagicLink = async (req, res) => {
  try {
    const { email } = req.body;
    await authService.requestMagicLink(email);
    res.status(200).json({ message: "Magic link sent" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.verifyMagicLink = async (req, res) => {
  try {
    const { token } = req.params;
    const { jwtToken, user } = await authService.verifyMagicLink(token);
    res.status(200).json({ token: jwtToken, user: user });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.accountRecovery = async (req, res) => {
  try {
    const { email } = req.body;
    await authService.passwordRecovery(email);
    res.status(200).json({ message: "Recovery email sent" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.resetPassword = async (req, res) => {
  try {
    const { email, code, password } = req.body;
    await authService.resetPassword(email, code, password);
    res.status(200).json({ message: "Password reset successfully" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
