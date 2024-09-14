import 'dart:convert';

import 'package:assan_khata_frontend/core/common/api_service.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/data/models/recipe_model.dart';

class RecipeDatasource {
  ApiService apiService;

  RecipeDatasource({required this.apiService});

  Future<List<RecipeModel>> getRecipes(String token) async {
    try {
      final result = await apiService.get('/external-api/recipe/$token');
      final responseBody = jsonDecode(result.body);
      return responseBody
          .map<RecipeModel>((expense) => RecipeModel.fromJson(expense))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recipe: ${e.toString()}');
    }
  }
}
