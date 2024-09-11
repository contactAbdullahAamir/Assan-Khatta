const recipeController = require("../controllers/recipe.controller");

const express = require("express");

const router = express.Router();

router.get("/:token", recipeController.getRecipes);
router.post("/:token/:recipeId/favorite", recipeController.toggleFavorite);

module.exports = router;
