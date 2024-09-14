class RecipeEvent {}

class GetRecipeEvent extends RecipeEvent {
  final String token;

  GetRecipeEvent({required this.token});
}
