import 'package:cookbook_ia/domain/entities/recipe.dart';
import 'package:equatable/equatable.dart';

class RecipeResponse extends Equatable {

  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  
  const RecipeResponse({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    name,
    ingredients,
    instructions
  ];


 factory RecipeResponse.fromJson(Map<String, dynamic> json) =>
      RecipeResponse(
        id: json['id'],
        name: json['name'] , 
        ingredients:  List<String>.from(json["ingredients"].map((x) => x)), 
        instructions:  List<String>.from(json["instructions"].map((x) => x)), 
  );
  
  Recipe toEntity() {
    return Recipe(
      id: id,
      name: name,
      ingredients: ingredients,
      instructions: instructions
      );
  }

}