const axios = require("axios");

class authService {
  static async signup(userData) {
    try {
      const response = await axios.post(
        "https://c662-182-191-78-8.ngrok-free.app/auth/signup",
        userData
      );
      if (response.status === 201 || response.status === 200) {
        return response.data;
      } else {
        throw new Error("Failed to sign up");
      }
    } catch (error) {
      console.error("Error during sign-up:", error);
      throw error;
    }
  }

  static async login(userData) {
    try {
      const response = await axios.post(
        "https://c662-182-191-78-8.ngrok-free.app/auth/login",
        userData
      );
      if (response.status === 200 || response.status === 201) {
        return response.data;
      } else {
        throw new Error("Failed to log in");
      }
    } catch (error) {
      console.error("Error during login:", error);
      throw error;
    }
  }

  static async verifyOtp(userData) {
    try {
      const response = await axios.post(
        "https://c662-182-191-78-8.ngrok-free.app/auth/verify",
        userData
      );
      if (response.status === 201 || response.status === 200) {
        return response.data;
      } else {
        throw new Error("Failed to verify OTP");
      }
    } catch (error) {
      console.error("Error during OTP verification:", error);
      throw error;
    }
  }
}

module.exports = authService;
