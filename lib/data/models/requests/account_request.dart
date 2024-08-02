import 'package:equatable/equatable.dart';

class AccountRequest extends Equatable {

  final String username;
  final String fullname;
  final String allergies;
  final String preferences;

  const AccountRequest({
    required this.username,
    required this.fullname,
    required this.allergies,
    required this.preferences
  });

    @override
  List<Object?> get props => [
    username,
    fullname,
    allergies,
    preferences
  ];


}