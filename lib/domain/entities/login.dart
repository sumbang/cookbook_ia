
import 'package:equatable/equatable.dart';

class Login extends Equatable {

  final String uuid;
  final String fullname;
  final String username;
  final bool activated;
  
  const Login({
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

}