
import 'package:equatable/equatable.dart';

class Recipe extends Equatable {

  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  
  const Recipe({
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


  String valueToShare() {
    String returnValue = this.name+" \n\r";
    returnValue+= "\n\r\Ingrédients : \n\r";
    for(var i = 0; i < this.ingredients.length; i++) {
      returnValue+= this.ingredients[i].toString()+", ";
    }
    returnValue+= "\n\r\Instructions : \n\r";
    for(var i = 0; i < this.instructions.length; i++) {
      returnValue+= this.instructions[i].toString()+"\n\r";
    }
    return returnValue;
  }

}