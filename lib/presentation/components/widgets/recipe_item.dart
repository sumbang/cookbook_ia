import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/domain/entities/recipe.dart';
import 'package:cookbook_ia/presentation/screens/mobile/recipe_bookmark_screen.dart';
import 'package:flutter/material.dart';


class RecipeItem extends StatelessWidget {

  final Recipe recipe;

  RecipeItem({required this.recipe});

  @override
  Widget build(BuildContext context) {

      return GestureDetector(onTap: () {

         Navigator.push(context,
            MaterialPageRoute(
              builder: (_) => RecipeBookmarkScreen(recette: recipe,)),
        );

      }, child : Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Setting.white,
                    border: Border.all(color: Setting.primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  margin: EdgeInsets.all(5),
                  child : Text(recipe.name, style: TextStyle(color: Setting.black,  fontSize: 16, fontFamily: 'Candara', fontWeight: FontWeight.normal, height: 1.5))
                )
      );
  }

}