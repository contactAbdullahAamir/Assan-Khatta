import 'package:assan_khata_frontend/recipe_app/features/recipe/domain/usecase/get_recipes.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/presentation/bloc/recipe_event.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/presentation/bloc/recipe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRecipeUsecase _getRecipeUsecase;

  RecipeBloc({required GetRecipeUsecase getRecipeUsecase})
      : _getRecipeUsecase = getRecipeUsecase,
        super(RecipeInitial()) {
    on<RecipeEvent>((event, emit) => emit(RecipeLoading()));
    on<GetRecipeEvent>(_getRecipes);
  }

  Future<void> _getRecipes(
      GetRecipeEvent event, Emitter<RecipeState> emit) async {
    try {
      final result =
          await _getRecipeUsecase(GetRecipeUsecaseParams(token: event.token));
      result.fold((failure) {
        emit(RecipeFailed(
            message: failure.errorMessage ?? 'An unknown error occurred'));
      }, (success) {
        emit(RecipesLoadedSuccess(recipes: success));
      });
    } catch (e) {
      emit(RecipeFailed(
          message: "An unexpected error occurred: ${e.toString()}"));
    }
  }
}
