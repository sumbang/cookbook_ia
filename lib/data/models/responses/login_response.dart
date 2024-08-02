
import 'package:cookbook_ia/domain/entities/login.dart';
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {

  final String uuid;
  final String fullname;
  final String username;
  final bool activated;
  
  const LoginResponse({
    required this.uuid,
    required this.fullname,
    required this.username,
    required this.activated
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
    uuid,
    fullname,
    username,
    activated,
  ];


 factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(
        uuid: json['uuid'] , 
        username: json['username'], 
        fullname: json['fullname'],
        activated: json['activated'],
  );


  Login toEntity() {
    return Login(
      uuid: uuid, 
      fullname: fullname, 
      username: username, 
      activated: activated);
  }

}