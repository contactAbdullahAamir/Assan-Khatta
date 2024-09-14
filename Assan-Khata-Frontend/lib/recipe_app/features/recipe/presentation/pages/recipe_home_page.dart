import 'package:assan_khata_frontend/core/common/entities/user.dart';
import 'package:assan_khata_frontend/recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class RecipeHomePage extends StatefulWidget {
  final UserEntity user;

  const RecipeHomePage({
    super.key,
    this.user = const UserEntity(),
  });

  static route(final user) =>
      MaterialPageRoute(builder: (context) => RecipeHomePage(user: user));

  @override
  State<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(GetRecipeEvent(token: widget.user.token!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: SafeArea(
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RecipeFailed) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is RecipesLoadedSuccess) {
              return ListView.builder(
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];
                  return ListTile(
                    title: Text(recipe.name ?? 'Unnamed Recipe'),
                    subtitle:
                        Text('Category: ${recipe.category ?? 'Uncategorized'}'),
                    trailing: Text('Price: ${recipe.price ?? 'N/A'}'),
                    onTap: () {
                      // Navigate to recipe details page
                      // You can implement this later
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('No recipes found'));
            }
          },
        ),
      ),
    );
  }
}
