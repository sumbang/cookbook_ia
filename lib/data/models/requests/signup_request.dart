import 'package:equatable/equatable.dart';

class SignupRequest extends Equatable {

  final String username;
  final String password;
  final String fullname;

  const SignupRequest({
    required this.username,
    required this.password,
    required this.fullname
  });

    @override
  List<Object?> get props => [
    username,
    password,
    fullname
  ];


}