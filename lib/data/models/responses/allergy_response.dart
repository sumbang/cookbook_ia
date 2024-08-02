import 'package:equatable/equatable.dart';

class AllergyResponse extends Equatable {

  final String name;
  final String percent;
  
  const AllergyResponse({
    required this.name,
    required this.percent
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    percent
  ];


 factory AllergyResponse.fromJson(Map<String, dynamic> json) =>
      AllergyResponse(
        name: json['name'] , 
        percent: json['percent'].toString(), 
  );


}