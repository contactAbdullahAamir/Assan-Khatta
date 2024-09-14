class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipesLoadedSuccess extends RecipeState {
  final recipes;

  RecipesLoadedSuccess({required this.recipes});
}

class RecipeFailed extends RecipeState {
  final message;

  RecipeFailed({required this.message});
}
