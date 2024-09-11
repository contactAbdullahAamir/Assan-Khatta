const express = require("express");
const authController = require("../controllers/auth.controller");
const passport = require("passport");

const router = express.Router();

router.post("/signup", authController.register);
router.post("/verify-email", authController.verifyEmail);
router.post("/login", authController.login);
router.post("/magic-link", authController.requestMagicLink);
router.get("/magic-link/:token", authController.verifyMagicLink);
router.get(
  "/signup/google",
  passport.authenticate("google", { scope: ["profile", "email"] })
);
router.get(
  "/signup/google/callback",
  passport.authenticate("google", { failureRedirect: "/" }),
  (req, res) => {
    res.json
  }
);

module.exports = router;
