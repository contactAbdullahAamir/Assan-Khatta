const recipeService = require("../services/recipe.service");

exports.getRecipes = async (req, res) => {
  try {
    const token = req.params.token;
    console.log(token);
    const result = await recipeService.getRecipes(token);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).send("Error during get recipe");
  }
};

exports.toggleFavorite = async (req, res) => {
  try {
    const token = req.params.token;
    const recipeId = req.params.recipeId;
    const result = await recipeService.toggleFavorite(token, recipeId);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).send("Error during toggle favorite");
  }
};
