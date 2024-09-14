import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/recipe_repository.dart';

class GetRecipeUsecase {
  final RecipeRepository repository;

  GetRecipeUsecase({required this.repository});

  Future<Either<DataFailed, List<RecipeEntity>>> call(
      GetRecipeUsecaseParams params) async {
    try {
      final recipes = await repository.getRecipes(params.token);
      return recipes;
    } catch (e) {
      return Left(DataFailed('Failed to get recipe: ${e.toString()}'));
    }
  }
}

class GetRecipeUsecaseParams {
  final String token;

  GetRecipeUsecaseParams({required this.token});
}
