import 'package:equatable/equatable.dart';

class RecipeRequest extends Equatable {

  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  
  const RecipeRequest({
    required this.name,
    required this.ingredients,
    required this.instructions
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    ingredients,
    instructions
  ];


}