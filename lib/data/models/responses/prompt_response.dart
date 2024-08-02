
import 'package:cookbook_ia/data/models/responses/recette_response.dart';
import 'package:equatable/equatable.dart';

class PromptResponse extends Equatable {

  final String status;
  final List<RecetteResponse> content;
  final String message;
  
  const PromptResponse({
    required this.status,
    required this.content,
    required this.message
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
    status,
    content,
    message
  ];


 factory PromptResponse.fromJson(Map<String, dynamic> json) =>
      PromptResponse(
        status: json['status'].toString() , 
        content : List<RecetteResponse>.from(json["content"].map((x) => RecetteResponse.fromJson(x))),
        message: json['message'], 
  );


}