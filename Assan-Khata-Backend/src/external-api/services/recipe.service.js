const axios = require("axios");

class recipeService {
  static async getRecipes(token) {
    try {
      const response = await axios.get(
        "https://c662-182-191-78-8.ngrok-free.app/recipes", {
          headers: {
            Authorization: "Bearer " + token,
          },
        }
      );
      if (response.status === 200) {
        return response.data;
      } else {
        throw new Error("Failed to get recipe");
      }
    } catch (error) {
      console.error("Error during get recipe:", error);
      throw error;
    }
  }

  static async toggleFavorite(token, recipeId) {
    try {
      const response = await axios.patch(
        `https://c662-182-191-78-8.ngrok-free.app/recipes/${recipeId}/favorite`,
        {}, // Provide an empty object or data if needed
        {
          headers: {
            Authorization: "Bearer " + token,
          },
        }
      );
      if (response.status === 200) {
        return response.data;
      } else {
        throw new Error("Failed to toggle favorite");
      }
    } catch (error) {
      console.error("Error during toggle favorite:", error);
      throw error;
    }
  }
  
}

module.exports = recipeService;
