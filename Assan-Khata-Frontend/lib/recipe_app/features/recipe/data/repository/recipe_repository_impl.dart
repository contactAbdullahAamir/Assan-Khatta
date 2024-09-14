import 'package:assan_khata_frontend/recipe_app/features/recipe/data/datasourcces/recipe_datasource.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/resources/data_source.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repository/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeDatasource remoteDataSource;

  const RecipeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<DataFailed, List<RecipeEntity>>> getRecipes(
      String token) async {
    try {
      final recipes = await remoteDataSource.getRecipes(token);
      return Right(recipes);
    } catch (e) {
      return Left(DataFailed('Failed to get recipe: ${e.toString()}'));
    }
  }
}
