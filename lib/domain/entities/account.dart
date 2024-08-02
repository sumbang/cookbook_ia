import 'package:equatable/equatable.dart';

class Account extends Equatable {

  final String allergies;
  final String preferences;
  
  const Account({
    required this.allergies,
    required this.preferences
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
   allergies,
   preferences
  ];

}