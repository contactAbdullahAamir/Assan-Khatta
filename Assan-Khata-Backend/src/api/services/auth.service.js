const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const crypto = require("crypto");
const User = require("../models/user.model");
const Wallet = require("../models/wallet.model");
const { Console } = require("console");

exports.registerUser = async (name, email, password) => {
  // Email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    throw new Error("Invalid email format");
  }
  const verificationCode = Math.floor(
    100000 + Math.random() * 900000
  ).toString();

  // Check if email already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    await sendVerificationEmail(email, verificationCode);
    throw new Error(
      "Email already registered, Please Check your email for verification code"
    );
  }

  // Password validation
  if (password.length < 8) {
    throw new Error("Password must be at least 8 characters long");
  }

  // You can add more password requirements here, for example:
  const passwordRegex =
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
  if (!passwordRegex.test(password)) {
    throw new Error(
      "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character"
    );
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = new User({
    name,
    email,
    password: hashedPassword,
    verificationCode,
  });

  await user.save();
  try {
    await sendVerificationEmail(email, verificationCode);
  } catch (emailError) {
    // If sending email fails, delete the user and throw an error
    await User.deleteOne({ _id: user._id });
    throw new Error(`Failed to send verification email: ${emailError.message}`);
  }
  try {
    const existingWallet = await Wallet.findOne({ userId: user._id });
    if (!existingWallet) {

      const newWallet = new Wallet({
        userId: user._id,
        balance: 0,
        currency: "PKR"
      });
      await newWallet.save();
    } else {
      Console.log('Existing wallet found', existingWallet);
    }
  } catch (walletError) {
    await User.deleteOne({ _id: user._id });
    throw new Error(`Failed to create wallet: ${walletError.message}`);
  }
  return user;
};

exports.loginUser = async (email, password) => {
  const user = await User.findOne({ email });

  if (!user) {
    throw new Error("User not found");
  }

  if (!user.isVerified) {
    throw new Error("Email not verified");
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    throw new Error("Incorrect password");
  }

  const jwtToken = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
    expiresIn: "1h",
  });
  if (io) {
    const userSocket = io.sockets.sockets.get(user._id.toString());
    if (userSocket) {
      userSocket.join(user._id.toString());
    }
  }

  global.io.to(user._id.toString()).emit("login", jwtToken);
  // Return both the token and the user
  return { jwtToken, user };
};

exports.verifyEmail = async (email, code) => {
  const user = await User.findOne({ email });

  if (!user || user.verificationCode !== code) {
    throw new Error("Invalid verification code");
  }

  user.isVerified = true;
  user.verificationCode = undefined;
  await user.save();

  return user;
};

exports.requestMagicLink = async (email) => {
  let user = await User.findOne({ email });

  if (!user) {
    user = new User({ email });
  }

  const token = crypto.randomBytes(32).toString("hex");
  const link = token;

  user.magicLinkToken = token;
  await user.save();
  try {
    console.log('Checking for existing wallet');
    const existingWallet = await Wallet.findOne({ userId: user._id });
    if (!existingWallet) {
      console.log('No existing wallet found, creating new wallet');
      const newWallet = new Wallet({
        userId: user._id,
        balance: 0,
        currency: "PKR"
      });
      await newWallet.save();
      console.log('New wallet created', newWallet);
    } else {
      console.log('Existing wallet found', existingWallet);
    }
  } catch (walletError) {
    console.error('Error creating wallet:', walletError);
    await User.deleteOne({ _id: user._id });
    throw new Error(`Failed to create wallet: ${walletError.message}`);
  }
  await sendMagicLinkEmail(email, link);
};

exports.verifyMagicLink = async (token) => {
  const user = await User.findOne({ magicLinkToken: token });

  if (!user) {
    throw new Error("Invalid magic link");
  }

  user.isVerified = true;
  await user.save();

  const jwtToken = jwt.sign({ User: user }, process.env.JWT_SECRET, {
    expiresIn: "1h",
  });

  return { jwtToken, user };
};

const sendVerificationEmail = async (email, code) => {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    port: 465,
    secure: true, // Use `true` for port 465, `false` for all other ports
    auth: {
      user: process.env.DEV_EMAIL,
      pass: process.env.DEV_EMAIL_PASSWORD,
    },
  });
  const mailOptions = {
    from: process.env.DEV_EMAIL,
    to: email,
    subject: "Verify your email",
    text: `Your verification code is ${code}`,
  };
  try {
    await transporter.sendMail(mailOptions);
    console.log("Verification email sent");
  } catch (err) {
    console.log(err);
  }
};

const sendMagicLinkEmail = async (email, link) => {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    port: 465,
    secure: true, // Use `true` for port 465, `false` for all other ports
    auth: {
      user: process.env.DEV_EMAIL,
      pass: process.env.DEV_EMAIL_PASSWORD,
    },
  });

  const mailOptions = {
    from: process.env.EMAIL,
    to: email,
    subject: "Your Magic Link",
    text: `Click on this link to login: ${link}`,
  };

  await transporter.sendMail(mailOptions);
};

exports.passwordRecovery = async (email) => {
  const user = await User.findOne({ email });

  if (!user) {
    throw new Error("User not found");
  }

  const verificationCode = Math.floor(
    100000 + Math.random() * 900000
  ).toString();

  await sendVerificationEmail(email, verificationCode);

  return user;
};

exports.resetPassword = async (email, code, password) => {
  const user = await User.findOne({ email });

  if (!user || user.verificationCode !== code) {
    throw new Error("Invalid verification code");
  }

  user.password = await bcrypt.hash(password, 10);
  user.verificationCode = undefined;
  await user.save();

  return user;
};
