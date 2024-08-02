import 'package:equatable/equatable.dart';

class RecetteResponse extends Equatable {

  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  
  const RecetteResponse({
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


 factory RecetteResponse.fromJson(Map<String, dynamic> json) =>
      RecetteResponse(
        name: json['name'] , 
        ingredients:  List<String>.from(json["ingredients"].map((x) => x)), 
        instructions:  List<String>.from(json["instructions"].map((x) => x)), 
  );



}