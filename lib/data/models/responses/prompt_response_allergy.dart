
import 'package:cookbook_ia/data/models/responses/allergy_response.dart';
import 'package:equatable/equatable.dart';

class PromptResponseAllergy extends Equatable {

  final String status;
  final List<AllergyResponse> content;
  final String message;
  
  const PromptResponseAllergy({
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


 factory PromptResponseAllergy.fromJson(Map<String, dynamic> json) =>
      PromptResponseAllergy(
        status: json['status'].toString() , 
        content : List<AllergyResponse>.from(json["content"].map((x) => AllergyResponse.fromJson(x))),
        message: json['message'], 
  );



}