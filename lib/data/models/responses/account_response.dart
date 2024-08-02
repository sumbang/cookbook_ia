import 'package:cookbook_ia/domain/entities/account.dart';
import 'package:equatable/equatable.dart';

class AccountResponse extends Equatable {

  final String allergies;
  final String preferences;
  
  const AccountResponse({
    required this.allergies,
    required this.preferences
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
   allergies,
   preferences
  ];

   factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      AccountResponse(
        allergies: json['allergies'],
        preferences: json['preferences']
  );

  Account toEntity() {
    return Account(
      allergies: allergies,
      preferences: preferences
      );
  }

}