class RecipeEntity {
  final String? id;
  final String? userId;
  final String? name;
  final int? size;
  final int? price;

  final List<dynamic>? ingredients;
  final List<dynamic>? steps;
  final String? image;
  final String? category;
  final bool? check;
  final int? cookCount;
  final bool? favorites;

  const RecipeEntity({
    this.id,
    this.userId,
    this.name,
    this.size,
    this.price,
    this.ingredients,
    this.steps,
    this.image,
    this.category,
    this.check,
    this.cookCount,
    this.favorites,
  });

  RecipeEntity copyWith({
    String? id,
    String? userId,
    String? name,
    int? size,
    int? price,
    List<dynamic>? ingredients,
    List<dynamic>? steps,
    String? image,
    String? category,
    bool? check,
    int? cookCount,
    bool? favorites,
  }) {
    return RecipeEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      size: size ?? this.size,
      price: price ?? this.price,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      image: image ?? this.image,
      category: category ?? this.category,
      check: check ?? this.check,
      cookCount: cookCount ?? this.cookCount,
      favorites: favorites ?? this.favorites,
    );
  }

  factory RecipeEntity.fromJson(Map<String, dynamic> map) {
    return RecipeEntity(
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
