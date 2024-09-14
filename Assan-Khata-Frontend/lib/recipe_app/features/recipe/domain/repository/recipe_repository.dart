import 'package:assan_khata_frontend/core/resources/data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<Either<DataFailed, List<RecipeEntity>>> getRecipes(String token);
}
