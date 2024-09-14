import 'package:assan_khata_frontend/recipe_app/features/recipe/domain/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  RecipeModel({
    required String? id,
    required String? userId,
    required String? name,
    required int? size,
    required int? price,
    required List<dynamic>? ingredients,
    required List<dynamic>? steps,
    required String? image,
    required String? category,
    required bool? check,
    required int? cookCount,
    required bool? favorites,
  }) : super(
            id: id,
            userId: userId,
            name: name,
            size: size,
            price: price,
            ingredients: ingredients,
            steps: steps,
            image: image,
            category: category,
            check: check,
            cookCount: cookCount,
            favorites: favorites);

  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['_id'] as String?,
      userId: map['userId'] as String?,
      name: map['name'] as String?,
      size: map['size'] as int?,
      price: map['price'] as int?,
      ingredients: map['ingredients'] as List<dynamic>?,
      steps: map['steps'] as List<dynamic>?,
      image: map['image'] as String?,
      category: map['category'] as String?,
      check: map['check'] as bool?,
      cookCount: map['cookCount'] as int?,
      favorites: map['favorites'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'name': name,
      'size': size,
      'price': price,
      'ingredients': ingredients,
      'steps': steps,
      'image': image,
      'category': category,
      'check': check,
      'cookCount': cookCount,
      'favorites': favorites,
    };
  }
}
